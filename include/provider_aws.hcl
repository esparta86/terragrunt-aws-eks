locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  aws_region       = local.account_vars.locals.aws_region
  aws_account_id   = local.account_vars.locals.aws_account_id
  assume_role_name = local.account_vars.locals.assume_role_name
  profile          = local.account_vars.locals.profile


  aws_account_id2   = local.account_vars.locals.aws_account_id2
  assume_role_name2 = local.account_vars.locals.assume_role_name2
  profile2          = local.account_vars.locals.profile2


}


generate "provider_aws" {
  path      = "provider_aws.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  profile = "${local.profile}"
  alias  = "aws1"
  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/${local.assume_role_name}"
  }
}

provider "aws" {
  region = "${local.aws_region}"
  alias  = "aws2"
  profile = "${local.profile2}"
  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id2}:role/${local.assume_role_name2}"
  }
}
EOF
}

generate "required_providers" {
  path = "required_aws.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9"
    }
  }

  # required_version = ">= 0.14.9"
  required_version = ">= 1.7.5"
}
EOF
    }
