resource "aws_ecs_cluster" "web-cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.test.name]
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecs_capacity_provider" "test" {
  name = "capacity-provider-test"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.nona_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}


# Containers and definitions

# update file container-def, so it's pulling image from ecr
resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "web-family"
  container_definitions = file("container-definitions/container-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-test.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    container_name   = "constellationjs-container"
    container_port   = 8082
  }

  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.web-listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}


# Eugene
resource "aws_ecs_task_definition" "task-definition-eugenelab" {
  family                = "eugenelab"
  container_definitions = file("container-definitions/eugenelab-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecs_service" "eugenelab_service" {
  name            = "eugenelab-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-eugenelab.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_lb_target_group.eugenelab_lb_target_group.arn}"
    container_name   = "eugenelab-container"
    container_port   = 8080
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.eugenelab-listener, aws_lb_listener.eugenelab-secure-listener]
}

resource "aws_cloudwatch_log_group" "eugenelab_log_group" {
  name = "/ecs/eugenelab-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

# fpselection
resource "aws_ecs_task_definition" "task-definition-fpselection" {
  family                = "fpselection"
  container_definitions = file("container-definitions/fpselection-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecs_service" "fpselection_service" {
  name            = "fpselection-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-fpselection.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_lb_target_group.fpselection_lb_target_group.arn}"
    container_name   = "fpselection-container"
    container_port   = 8080
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.fpselection-secure-listener]
}

resource "aws_cloudwatch_log_group" "fpselection_log_group" {
  name = "/ecs/fpselection-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

# parchmint
resource "aws_ecs_task_definition" "task-definition-parchmint" {
  family                = "parchmint"
  container_definitions = file("container-definitions/parchmint-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecs_service" "parchmint_service" {
  name            = "parchmint-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-parchmint.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_lb_target_group.parchmint_lb_target_group.arn}"
    container_name   = "parchmint-container"
    container_port   = 8080
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.parchmint-secure-listener]
}

resource "aws_cloudwatch_log_group" "parchmint_log_group" {
  name = "/ecs/parchmint-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}


# minieugene
resource "aws_ecs_task_definition" "task-definition-minieugene" {
  family                = "minieugene"
  container_definitions = file("container-definitions/minieugene-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecs_service" "minieugene_service" {
  name            = "minieugene-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-minieugene.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_lb_target_group.minieugene_lb_target_group.arn}"
    container_name   = "minieugene-container"
    container_port   = 8080
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.minieugene-secure-listener]
}

resource "aws_cloudwatch_log_group" "minieugene_log_group" {
  name = "/ecs/minieugene-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}
