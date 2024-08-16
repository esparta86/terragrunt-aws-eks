variable "instance_type" {
  description = "The instance type to use"
  type        = string
}
variable "subnet_private_id" {
  type = string
  description = "subnet id private "
}

variable "instance_name_server" {
  type = string
  description = "Instance name of server"
}


variable "subnet_public_list" {
  type = list(any)
  description = "list of ID subnets created by vpc module"
}


variable "instance_name" {
  description = "The name to use for the instance"
  type        = string
}

variable "vpc_id" {
    type = string
    description = "vpc id"
}

variable "default_tags" {
  default = {
    cloudprovider = "aws"
    owner         = "true"
  }
  description = "default tags name to tag in resources"
  type = map(string)
}



variable "cluster_security_group_rules_vms" {
  type = any
  default = {
    "ssh-anywhere" = {
       "type" = "ingress",
       "from_port" = 22,
       "to_port"   = 22,
       "protocol"  = "tcp",
       "cidr_blocks" = [ "0.0.0.0/0" ]
    }

    "all-traffic" = {
       "type" = "egress",
       "from_port" = 0,
       "to_port"   = 0,
       "protocol"  = "-1",
       "cidr_blocks" = [ "10.2.0.64/26","10.2.0.128/26" ]
    }
  }
}


variable "cluster_security_group_rules_bastion_server_vms" {
  type = any
  default = {
    "ssh-anywhere" = {
       "type" = "ingress",
       "from_port" = 22,
       "to_port"   = 22,
       "protocol"  = "tcp"
    }

    "all-traffic" = {
       "type" = "egress",
       "from_port" = 0,
       "to_port"   = 0,
       "protocol"  = "-1",
       "cidr_blocks" = [ "0.0.0.0/0" ]
    }
  }
}
