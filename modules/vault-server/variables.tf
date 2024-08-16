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


variable "private_vault_server" {
  type = bool
  default = true
  description = "Enable private vault server"
}

variable "instance_type" {
  default = "t2.micro"
}

# SSH key name to access EC2 instances (should already exist) in the AWS Region
variable "key_name" {
  default = "ubuntu"
}

variable "required_vault_server" {
  type = bool
  default = true

}

variable "vpc_id" {
  type = string
}


variable "ingress_rules_vault_server" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks = list(string)
  }))

  description = "List of ingress rules applied in the vault server"

  default = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  },
  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 8200
    protocol = "tcp"
    to_port = 8200
  } ]
}


variable "egress_rules_vault_server" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks = list(string)
  }))

  description = "List of ingress rules applied in the vault server"

  default = [
  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  ]
}


variable "external_aws" {
  # type = list(string)
  type = list(map(string))
  description = "List of AWS account numbers"
  # default = [ "22333" ]
  default = [ {
    "provider" = "aws2"
    "account"  = "2333"
  } ]
}
