terraform {
    source = "../../..//modules/aws-vpc-module"
}

inputs = {
  vpc_name = "main-colocho"
  vpc_cidr = "10.0.0.0/16"
  enable_compute_ng_default = false
}

include {
    path = find_in_parent_folders()
}
