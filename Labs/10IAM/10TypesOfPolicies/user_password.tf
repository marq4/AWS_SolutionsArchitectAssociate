
locals {
  users = {
    "PoliciesExample.User" = {
      name  = "Policies Example User"
      email = "policies.example.user@example.com"
    }
  }
}

resource "aws_iam_user" "IAM-users" {
  for_each = local.users

  name          = each.key
  force_destroy = false
}

resource "pgp_key" "PGP-keys" {
  for_each = local.users

  name  = each.value.name
  email = each.value.email

  comment = "PGP key for ${each.value.name}"
}

resource "aws_iam_user_login_profile" "user-login" {
  for_each = local.users

  user                    = each.key
  pgp_key                 = pgp_key.PGP-keys[each.key].public_key_base64
  password_reset_required = true

  depends_on = [aws_iam_user.IAM-users]
}

data "pgp_decrypt" "user_password_decrypt" {
  for_each = local.users

  ciphertext          = aws_iam_user_login_profile.user-login[each.key].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.PGP-keys[each.key].private_key
}

output "InitialPassword" {
  value = {
    for k, v in local.users : k => {
      "password" = data.pgp_decrypt.user_password_decrypt[k].plaintext
    }
  }
  #sensitive = true
}

