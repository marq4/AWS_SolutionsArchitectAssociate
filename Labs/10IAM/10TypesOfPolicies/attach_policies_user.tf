
resource "aws_iam_user_policy_attachment" "PoliciesExampleUser-changepassword" {
  for_each = local.users

  user       = each.key
  policy_arn = aws_iam_policy.allow-user-change-their-own-password.arn
}

resource "aws_iam_user_policy_attachment" "PoliciesExampleUser-ReadOnly" {
  for_each = local.users

  user       = each.key
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}

resource "aws_iam_user_policy_attachment" "PoliciesExampleUser-S3All" {
  for_each = local.users

  user       = each.key
  policy_arn = aws_iam_policy.s3-all-access.arn
}
