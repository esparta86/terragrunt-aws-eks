locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  aws_region       = local.account_vars.locals.aws_region
  aws_account_id   = local.account_vars.locals.aws_account_id
  assume_role_name = local.account_vars.locals.assume_role_name
}


generate "provider_aws" {
  path      = "provider_aws.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/${local.assume_role_name}"
  }
}
EOF
}
