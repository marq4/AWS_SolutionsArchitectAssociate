resource "aws_ecr_repository" "lambdas-repo" {
  name = "lambdas-repo"
  image_scanning_configuration {
    scan_on_push = false
  }
}
