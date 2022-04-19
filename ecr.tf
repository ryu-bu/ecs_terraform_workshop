resource "aws_ecr_repository" "eugene_repo" {
  name                 = "eugenerepo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecr_lifecycle_policy" "eugene_repo_policy" {
  repository = aws_ecr_repository.eugene_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
resource "aws_ecr_repository" "constellationjs_repo" {
  name                 = "constellationjs"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    "env"       = "dev"
    "createdBy" = "gjohnson"
  }
}

resource "aws_ecr_lifecycle_policy" "constellationjs_repo_policy" {
  repository = aws_ecr_repository.constellationjs_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
