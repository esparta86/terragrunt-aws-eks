

terraform {
    source = "../../..//modules/vpc"
}

inputs = {
    vpc_cidr = "10.0.0.0/16"
    default_tags =  {
       cloudprovider = "aws"
       owner         = "lisandro"
       environment   =  "dev"
    }
}


include {
    path = find_in_parent_folders()
}