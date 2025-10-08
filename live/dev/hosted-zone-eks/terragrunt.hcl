terraform {
    source = "../../..//modules/hosted-zone-eks"
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

include {
    path = find_in_parent_folders()
}

inputs = {

  domain_zone_name = "esparta86.com"

}
