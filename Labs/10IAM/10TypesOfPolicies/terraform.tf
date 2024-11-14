
terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
    pgp = {
      source = "ekristen/pgp"
    }

  }
}
