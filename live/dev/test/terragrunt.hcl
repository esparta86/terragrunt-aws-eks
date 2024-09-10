terraform {
    source = "../../../modules/test"
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

include {
    path = find_in_parent_folders()
}

inputs = {
  environment = "dev"
}
