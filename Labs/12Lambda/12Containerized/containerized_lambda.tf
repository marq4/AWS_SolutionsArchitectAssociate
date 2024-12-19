data "aws_iam_policy_document" "assume-role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role-for-lambda" {
  name               = "role-for-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}


resource "aws_lambda_function" "containerized" {
  function_name = "nightclub_access"
  description   = "Greets user if they're old enough to enter the club."
  package_type  = "Image"
  image_uri     = "638471508911.dkr.ecr.us-east-2.amazonaws.com/lambdas-repo:2"
  role          = aws_iam_role.role-for-lambda.arn
}
