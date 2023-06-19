

terraform {
    source = "../../..//modules/ec2-instance"
}

inputs = {
    instance_type = "t2.medium"
    instance_name = "nginx-server"
    subnet_public_list = dependency.vpc.outputs.subnets_public_ids
    security_group_nginx_id = dependency.vpc.outputs.security_group_ngix_id
}


include {
    path = find_in_parent_folders()
}

dependency "vpc" {
    config_path = "../vpc"
}