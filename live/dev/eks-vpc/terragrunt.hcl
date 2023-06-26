

terraform {
    source = "../../..//modules/eks-vpc"
}

inputs = {
    eks_vpc_cidr = "10.0.0.0/16"
    version_eks_deployment = "1.25"
    default_tags =  {
       cloudprovider = "aws"
       owner         = "lisandro"
       environment   =  "dev"
       purpose       =  "eks cluster"
    }
}


include {
    path = find_in_parent_folders()
}