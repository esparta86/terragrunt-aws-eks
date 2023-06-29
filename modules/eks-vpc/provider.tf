
provider "aws" {
  region = "us-east-1"
  profile = "personal"
  assume_role {
    # role_arn = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/RolePowerUserAccess"
  }
}

