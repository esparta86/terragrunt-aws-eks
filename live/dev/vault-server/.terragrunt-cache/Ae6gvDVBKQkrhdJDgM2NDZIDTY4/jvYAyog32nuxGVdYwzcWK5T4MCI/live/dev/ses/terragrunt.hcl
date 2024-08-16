terraform {
    source = "../../..//modules/aws-ses"
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

inputs = {
  hosted_zone_domain = "esparta86.com"


}

include {
    path = find_in_parent_folders()
}
