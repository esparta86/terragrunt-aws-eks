include "root" {
    path = find_in_parent_folders("root.hcl")
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

terraform {
  source = "../../..//modules/s3"
}


inputs = {
  hybrik_output_name = "nonprd-output-colocho"
  
  # custom_life_cicle_rules = [
  #   {
  #     id      = "cleanup - fmp"
  #     enabled = true
  #     filter  = { prefix = "fmp/" }
  #     expiration = {
  #       days                         = 1
  #       expired_object_delete_marker = false
  #     }
  #   },
  #   {
  #     id      = "cleanup - lht"
  #     enabled = true
  #     filter  = { prefix = "lht/" }
  #     expiration = {
  #       days                         = 1
  #       expired_object_delete_marker = false
  #     }
  #   },
  #       {
  #     id      = "cleanup - PREPRD/clip"
  #     enabled = true
  #     filter  = { prefix = "PREPRD/clip" }
  #     expiration = {
  #       days                         = 1
  #       expired_object_delete_marker = false
  #     }
  #   } 
  # ]
}
