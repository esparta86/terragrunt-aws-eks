
variable "eks_vpc_cidr" {
  description = "cidr for eks vpc"
  type = string
  default = "10.0.0.0/16"
}

variable "default_tags" {
  default = {
    cloudprovider = "aws"
    owner         = "devops-team"
    Terraform     = "true"
    Environment   = "Development"
  }
  description = "Default tags name to tag in resources"
  type        = map(string)
}


