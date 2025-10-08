


locals {
  account_domain_zone = {
    "${var.domain_zone_name}" = {
        comment =" hosted zone for dev "
        tags = {
            env = "dev"
        }
    }
  }
}


module "domain_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.10"

  zones = local.account_domain_zone
  tags  = {
     env = "dev"
     ManagedBy  = "terraform"
  }
}
