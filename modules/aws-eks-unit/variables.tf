variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "Name of eks"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}

variable "single_nat_gateway" {
  description = "If true, only a single NAT gateway will be created. If false, one NAT gateway per availability zone will be created."
  type        = bool
  default     = false
}

variable "enable_secondary_ips_nat" {
  description = "If true, enable secondary IPs for NAT gateways"
  type        = bool
  default     = false
}

# variable "one_nat_gateway_per_az" {
#   description = "If true, one NAT gateway will be created per availability zone. If false, a single NAT gateway will be created."
#   type        = bool
#   default     = false
# }

variable "eks_version" {
  description = "EKS version to use"
  type        = string
  default     = "1.32"
}

variable "cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "list of the desired control plane logs to enable, more information https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
}

variable "authentication_mode" {
  description = "Authentication mode for the EKS cluster"
  type        = string
  default     = "API"
  # Possible values: API, API_AND_CONFIG_MAP, CONFIG_MAP
}


variable "bootstrap_cluster_creator_admin_permissions" {
  description = "If true, the bootstrap cluster creator will have admin permissions on the EKS cluster"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Indicates whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Indicates whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)

}

variable "eks_service_ipv4cidr" {
  description = "CIDR block for the EKS service network"
  type        = string

}



variable "kms_setting" {
  description = "KMS settings for EKS cluster encryption"
  type = object({
    kms_deletion_window_in_days = number
    encryption_key_arn          = optional(string)
    enable_key_rotation         = optional(bool, true)
  })

  default = {
    kms_deletion_window_in_days = 7
    encryption_key_arn          = ""
    enable_key_rotation         = true
  }
}


variable "upgrade_policy_type" {
  description = "Upgrade policy type for the EKS cluster"
  type        = string
  default     = "STANDARD"
}

variable "eks_timeout" {
  type = map(string)
  default = {
    create = "40m"
    delete = "1h"
    update = "1h"
  }
}



variable "create_eks_cluster_sg" {
  description = "If true, create a security group for the EKS cluster"
  type        = bool
  default     = true
}


variable "cluster_security_group_additional_rules" {
  description = "Additional security group rules for the EKS cluster"
  type        = any
  default     = {}
  # type        = list(object({
  #   description = string
  #   from_port   = number
  #   to_port     = number
  #   protocol    = string
  #   cidr_blocks = optional(list(string), [])
  # }))
  # default     = []
}

variable "node_security_group_enable_recommended_rules" {
  description = "If true, enable recommended security group rules for the EKS node group"
  type        = bool
  default     = true
}



variable "eks_managed_node_groups" {
  description = "Map of EKS managed node groups to create. The key is the name of the node group, and the value is a map of parameters for the node group."
  type        = map(any)
  default     = {}
}
