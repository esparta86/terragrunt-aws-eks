
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


##### EKS VARIABLES ######

variable "cluster_deployment_name" {
  type = string
  default = "eks_deployment01"
}


variable "version_eks_deployment" {
  default     = "1.25"
  description = "version cluster"
  type        = string
}


variable "instance_types_workers_eks" {
  default = "t2.medium"
  description = "Instance type of VM that are going to work as workers"
}