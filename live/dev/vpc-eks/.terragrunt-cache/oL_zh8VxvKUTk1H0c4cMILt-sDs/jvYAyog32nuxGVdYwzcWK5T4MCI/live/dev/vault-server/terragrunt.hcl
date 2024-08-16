terraform {
    source = "../../..//modules/vault-server"
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

inputs = {
  environment_name = "nonprd-vault"
  vpc_cidr = "10.1.0.0/16"
  private_subnets = [ dependency.vpc.outputs.subnet_private_1_account_a_id, dependency.vpc.outputs.subnet_private_2_account_a_id]
  public_subnets  = dependency.vpc.outputs.subnets_public_account_a_ids
  vpc_id             = dependency.vpc.outputs.vpc_account_a_id
  private_vault_server = false
  external_aws = [
    {
    "provider" = "aws2"
    "account"  = "471112715935"
    }
  ]
}

include {
    path = find_in_parent_folders()
}


dependency "vpc" {
    config_path = "../vpc"
}
