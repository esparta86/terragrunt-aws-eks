module "vault_demo_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.environment_name}-vpc"
  cidr = var.cidr_vpc

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    Name = "${var.environment_name}-vpc"
  }
}
