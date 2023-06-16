variable "vpc_cidr" {
  description = "cidr for vpc"
  type        = string
  default     = "10.0.0.0/16"
}


variable "private_subnet_cidr" {
  description = "cidr for subnet vpc"
  type        = string
  default     = "10.0.0.64/26"
}


variable "default_tags" {
  default = {
    cloudprovider = "aws"
    owner         = "true"
  }
  description = "default tags name to tag in resources"
  type = map(string)
}


variable "igw_tags" {
  description = "tags igw_name"
  type        = map(string)
  default = {
    "Name" = "igw_vpc"
  }
}

variable "private_subnet_tags" {
  description = "tags for private subnet"
  type        = map(string)
  default = {
    "Name" = "private_subnet"
  }
}


variable "azs" {
  description = "The availability zones to spread nodes in"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
    ]
  type = list(string)
}
