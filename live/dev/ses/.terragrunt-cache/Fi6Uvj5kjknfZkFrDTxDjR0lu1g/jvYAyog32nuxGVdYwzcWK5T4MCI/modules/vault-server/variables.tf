variable "aws_region" {
  default = "us-east-1"
}

variable "cidr_vpc" {
    type = string
    default = "10.1.0.0/16"
}

variable "availability_zones" {
  type = list(string)
  default = [ "us-east-1a"]
}


variable "environment_name" {
  default = "vault-server"
}

variable "private_subnets" {
    type = list(string)
    default = [ "10.1.1.0/24" ]
    description = "List of CIDR for privateSubnets"
}

variable "public_subnets" {
    type = list(string)
    default = [ "10.1.101.0/24" ]
    description = "List of CIDR for publicSubnets"
}
