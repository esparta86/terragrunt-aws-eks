

terraform {
    source = "../../..//modules/ec2-instance"
}

inputs = {
    instance_type = "t2.micro"
    instance_name = "example-server-dev"
    subnet_public_list = dependency.vpc.outputs.subnets_public_ids
}


include {
    path = find_in_parent_folders()
}

dependency "vpc" {
    config_path = "../vpc"
}