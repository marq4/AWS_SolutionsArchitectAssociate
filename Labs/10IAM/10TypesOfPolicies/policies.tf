
resource "aws_iam_policy" "s3-all-access" {
  name        = "s3-all-access"
  description = "Allow user to do everything under S3 (all resources). "
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "allow-user-change-their-own-password" {
  name        = "allow-user-change-their-own-password"
  description = "Allow new users to change their password. "
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iam:ChangePassword"]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    }
  )
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
