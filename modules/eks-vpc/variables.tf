
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
  default = "eks_colocho86"
}

variable "create_node_security_group" {
  type = bool
  default = false
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


# variable "AWS_ACCOUNT_ID" {
#   type = string

# }

variable "region" {
  type = string
  description = "region"
}

variable "cloudwatch_namespace" {
  type = string
  description = "namespace"
}

variable "eks-service_account-name" {
  type = string
  description = "service account name"
}

variable "cluster_log_types" {
  type = list(string)
  default = ["api","audit","authenticator","controllerManager","scheduler"]
  description = "list of the desired control plane logs to enable, more information https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "eks_timeout" {
  type = map(string)
  default = {
    create = "40m"
    delete = "1h"
    update = "1h"
  }
}

variable "eks_service_ipv4cidr" {
  type = string
  description = "The CIDR block to assign k8s service IP,please provide a block that does not overlap with resources in other networks, more information https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-eks-cluster-kubernetesnetworkconfig.html"
}


variable "values_override_file" {
  type    = string
  default = ""
}


/// security group

variable "node_security_group_name" {
  type = string
  description = "name of security group"
  default = null
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source"
  type        = any
  default     = {}
}