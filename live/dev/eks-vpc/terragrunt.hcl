

terraform {
    source = "../../..//modules/eks-vpc"
}

inputs = {
    region = "us-east-1"
    eks_vpc_cidr = "10.0.0.0/16"
    version_eks_deployment = "1.26"
    cloudwatch_namespace = "amazon-cloudwatch"
    eks-service_account-name = "fluent-bit"
    default_tags =  {
       cloudprovider = "aws"
       owner         = "lisandro"
       environment   =  "dev"
       purpose       =  "eks cluster"
    }
    cluster_log_types = ["api","audit"]
    eks_service_ipv4cidr = "10.100.0.0/16"
    create_node_security_group = true
    node_security_group_additional_rules = {
    ingress_cluster_ssh = {
      description                   = "Allow SSH"
      protocol                      = "tcp"
      from_port                     = 22
      to_port                       = 22
      type                          = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    }
}


include {
    path = find_in_parent_folders()
}