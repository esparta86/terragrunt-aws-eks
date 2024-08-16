

terraform {
    source = "../../..//modules/vpc"
}

inputs = {

    # VAULT WITH AWS AUTH ACCROSS ACCOUNT
    vpc_cidr = "10.2.0.0/16"
    default_tags =  {
       cloudprovider = "aws"
       owner         = "lisandro"
       environment   =  "dev"
    }
    required_second_vpc = true
    vpc_cidr2 = "10.3.0.0/16"
    required_nat_main_vpc = true
    required_private_subnets = true



}


include {
    path = find_in_parent_folders()
}
