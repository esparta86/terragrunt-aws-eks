

terraform {
    source = "../../..//modules/vpc"
}

inputs = {
    vpc_cidr = "10.2.0.0/16"
    default_tags =  {
       cloudprovider = "aws"
       owner         = "lisandro"
       environment   =  "dev"
    }
    required_nat_main_vpc = false
    required_private_subnets = false
}


include {
    path = find_in_parent_folders()
}
