

terraform {
    source = "../../..//modules/eks-vpc"
}

inputs = {
    region = "us-east-1"
    eks_vpc_cidr = "10.0.0.0/16"
    version_eks_deployment = "1.25"
    cloudwatch_namespace = "amazon-cloudwatch"
    eks-service_account-name = "fluent-bit"
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