include "root" {
    path = find_in_parent_folders("root.hcl")
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

include "eks-unit" {
  path = find_in_parent_folders("include/eks-unit.hcl")
  expose = true
}

terraform {
#   source = "../../modules/aws-eks-unit"
  source = include.eks-unit.locals.source_base_url
}

inputs = {

   default_tags = {
     environment = "dev"
     tool        = "terragrunt"
     owner       = "esparta86"
   }

   name =  basename(get_original_terragrunt_dir())
   vpc_cidr_block = "10.0.0.0/16"
   eks_service_ipv4cidr = "10.100.0.0/16"

   kms_setting = {
     kms_deletion_window_in_days = 7
     enable_key_rotation = true
     
   }

   upgrade_policy_type = "STANDARD"
   endpoint_public_access_cidrs =  ["179.5.60.12/32", "179.5.62.92/32", "131.226.46.151/32","190.57.9.100/32"]
   

   create_eks_cluster_sg = true
   enable_secondary_ips_nat = false
   
}
