terraform {
    source = "../../..//modules/vault-server"
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

inputs = {
  environment_name = "nonprd-vault"
  vpc_cidr = "10.1.0.0/16"
  private_subnets = ["10.1.1.0/24"]
  public_subnets = [ "10.1.101.0/24" ]
  # cluster_sg_tags = {
  #   "karpenter.sh/discovery" = "ex-aws-vpc-module"
  # }

  # map_roles_aws = [
  #   {
  #     rolearn = "arn:aws:iam::734237051973:role/RolePowerColocho"
  #     username = "admin-colocho"
  #     groups = ["system:masters"]
  #   },
  #   {
  #     rolearn = "arn:aws:iam::734237051973:role/KarpenterNodeRole-ex-aws-vpc-module"
  #     username = "system:node:{{EC2PrivateDNSName}}"
  #     groups = ["system:bootstrappers","system:nodes"]
  #   }
  # ]
}

include {
    path = find_in_parent_folders()
}
