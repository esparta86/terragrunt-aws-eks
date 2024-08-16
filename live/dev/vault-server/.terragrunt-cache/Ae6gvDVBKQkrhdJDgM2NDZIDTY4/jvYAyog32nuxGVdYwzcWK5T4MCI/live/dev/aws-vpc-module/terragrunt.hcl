terraform {
    source = "../../..//modules/aws-vpc-module"
}

inputs = {
  vpc_name = "main-colocho"
  vpc_cidr = "10.0.0.0/16"
  enable_compute_ng_default = false

  cluster_sg_tags = {
    "karpenter.sh/discovery" = "ex-aws-vpc-module"
  }

  map_roles_aws = [
    {
      rolearn = "arn:aws:iam::734237051973:role/RolePowerColocho"
      username = "admin-colocho"
      groups = ["system:masters"]
    },
    {
      rolearn = "arn:aws:iam::734237051973:role/KarpenterNodeRole-ex-aws-vpc-module"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = ["system:bootstrappers","system:nodes"]
    }
  ]
}

include {
    path = find_in_parent_folders()
}
