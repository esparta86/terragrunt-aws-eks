data "aws_availability_zones" "available" {
    filter {
    name   = "zone-name"
    values = var.azs
  }
}

data "aws_caller_identity" "current" {}