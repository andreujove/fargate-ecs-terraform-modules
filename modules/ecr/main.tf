resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.name_prefix}"
  image_tag_mutability = var.image_mutability
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}