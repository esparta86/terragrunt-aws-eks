
include "root" {
    path = find_in_parent_folders("root.hcl")
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

include "vpc-services" {
  path = find_in_parent_folders("include/vpc-services.hcl")
  expose = true
}

dependency "aws-vpc-module" {
  config_path = find_in_parent_folders("aws-vpc-module")
}

terraform {
    source = include.vpc-services.locals.source_base_url
}


inputs = {

    # VPC ID and subnets from the dependency
    vpc_id = dependency.aws-vpc-module.outputs.vpc_id
    private_subnets = dependency.aws-vpc-module.outputs.private_subnets
    public_subnets = dependency.aws-vpc-module.outputs.public_subnets

    # granular_security_groups = true


   map_efs = [
     {
       name = "efs-colocho"
       performance_mode = "generalPurpose"
       tags = {
         Name = "efs-colocho"
         Environment = "dev"
       }
       lifecycle_policy = {
         transition_to_ia = "AFTER_7_DAYS"
        #  transition_to_archive = "AFTER_30_DAYS"
        #  transition_to_primary_storage_class = "AFTER_1_ACCESS"
       }
       protection = true
       throughput_mode = "elastic"
       create_mount_targets = true
       granular_security_groups = false
      #  availability_zone_name = "us-east-1c"
     }
   ]

}
