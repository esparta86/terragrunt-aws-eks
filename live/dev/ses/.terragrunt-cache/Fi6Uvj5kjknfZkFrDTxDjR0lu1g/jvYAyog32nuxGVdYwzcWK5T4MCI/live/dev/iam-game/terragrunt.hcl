

terraform {
    source = "../../..//modules/iam-play"
}

inputs = {
    # vpc_cidr = "10.2.0.0/16"
    # default_tags =  {
    #    cloudprovider = "aws"
    #    owner         = "lisandro"
    #    environment   =  "dev"
    # }
    instance_type = "t2.small"
    instance_name = "public-server"
    subnet_public_list = dependency.vpc.outputs.subnets_public_ids
    # security_group_nginx_id = dependency.vpc.outputs.security_group_ngix_id
    instance_name_server = "private-server"
    # security_group_mysql_id = dependency.vpc.outputs.security_group_mysql_id
    subnet_private_id = dependency.vpc.outputs.subnet_private_id
    vpc_id = dependency.vpc.outputs.vpc_id

}


include {
    path = find_in_parent_folders()
}


dependency "vpc" {
    config_path = "../vpc"
}
