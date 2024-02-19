provider "aws" {
  region = "us-east-1"
  profile = "personal"
  assume_role {
    role_arn = "arn:aws:iam::734237051973:role/RolePowerUserAccess"
  }
}