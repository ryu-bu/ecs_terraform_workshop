data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_security_group" "ec2-sg" {
  name        = "allow-all-ec2"
  description = "allow all"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gjohnson"
  }
}

resource "aws_launch_configuration" "lc" {
  name          = "test_ecs"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = aws_iam_instance_profile.ecs_service_role.name
  key_name                    = var.key_name
  security_groups             = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = "test-asg"
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = module.vpc.public_subnets

  target_group_arns     = [aws_lb_target_group.lb_target_group.arn]
  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nona_lc" {
  name          = "nona_ecs"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = aws_iam_instance_profile.ecs_service_role.name
  key_name                    = var.key_name
  security_groups             = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
echo ECS_CLUSTER=nona-research-foundation >> /etc/ecs/ecs.config

# install the Docker volume plugin
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=us-east-1 --grant-all-permissions

# restart the ECS agent
sudo systemctl restart ecs
EOF
}

resource "aws_autoscaling_group" "nona_asg" {
  name                      = "nona-asg"
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = 3
  max_size                  = 3
  desired_capacity          = 3
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = module.vpc.public_subnets

  target_group_arns     = [aws_lb_target_group.lb_target_group.arn, aws_lb_target_group.eugenelab_lb_target_group.arn, aws_lb_target_group.fpselection_lb_target_group.arn, aws_lb_target_group.minieugene_lb_target_group.arn, aws_lb_target_group.cellov1_lb_target_group.arn, aws_lb_target_group.clothov4_lb_target_group.arn, aws_lb_target_group.cellov2_lb_target_group.arn,]
  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }
}