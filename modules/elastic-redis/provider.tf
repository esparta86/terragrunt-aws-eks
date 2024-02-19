provider "aws" {
  region = "us-east-1"
  profile = "personal"
  assume_role {
    role_arn = "arn:aws:iam::AWS_ACCOUNT:role/YOUR_ROLE"
  }
}
