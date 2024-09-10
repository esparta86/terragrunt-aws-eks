provider "aws" {
  region = "us-east-1"
  profile = "personal"
  assume_role {
    role_arn = "ROLE_ACCOUNT_ID_1"
  }
