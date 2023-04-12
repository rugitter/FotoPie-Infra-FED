# Create IAM ECS Task Execution Role at first time
resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.application_name
  image_tag_mutability = "MUTABLE"
}