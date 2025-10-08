

terraform {
    source = "../../..//modules/vpc"
}


include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

inputs = {

    # VAULT WITH AWS AUTH ACCROSS ACCOUNT
    vpc_cidr = "10.2.0.0/16"
    default_tags =  {
       name       = "ste-use1-1"
       cloudprovider = "aws"
       owner         = "lisandro"
       environment   =  "dev"
       managedBy     = "Terraform"
    }
    required_second_vpc = false
    vpc_cidr2 = "10.3.0.0/16"
    required_nat_main_vpc = true
    required_private_subnets = true



}


include {
    path = find_in_parent_folders()
}
