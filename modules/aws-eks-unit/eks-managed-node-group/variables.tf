
variable "create_node_group" {
    description = "If true, create the EKS managed node group"
    type        = bool
    default     = true
}

variable "cluster_name" {
    description = "Name of the EKS cluster to which the node group will be attached"
    type        = string    
}

variable "cluster_endpoint" {
    description = "Endpoint of the EKS cluster to which the node group will be attached"
    type        = string
}

variable "cluster_version" {
    description = "Version of the EKS cluster to which the node group will be attached"
    type        = string
}


# variable "cluster_certificate_authority_data" {
#     description = "Certificate authority data of the EKS cluster to which the node group will be attached"
#     type        = optional(string)
#     default = ""
    
# }

variable "name" {
    description = "Name of the EKS managed node group"
    type        = string
}

variable "subnet_ids" {
    description = "List of subnet IDs where the EKS managed node group will be created"
    type        = list(string)
}

variable "min_size" {
    description = "Minimum size of the EKS managed node group"
    type        = number
    default     = 1
}

variable "max_size" {
    description = "Maximum size of the EKS managed node group"
    type        = number
    default     = 3
}
variable "desired_size" {
    description = "Desired size of the EKS managed node group"
    type        = number
    default     = 2
}

variable "ami_id" {
    description = "AMI ID for the EKS managed node group"
    type        = optional(string)
    default     = null 
}

variable "ami_type" {
    description = "AMI type for the EKS managed node group"
    type        = string
    default     = null
}

variable "ami_release_version" {
    description = "AMI release version for the EKS managed node group"
    type        = string
    default     = null  
}

variable "capacity_type" {
    description = "Capacity type for the EKS managed node group (e.g., ON_DEMAND, SPOT)"
    type        = string
    default     = "ON_DEMAND"   
}

variable "disk_size" {
    description = "Disk size for the EKS managed node group in GiB"
    type        = optional(number)
    default     = null
}

variable "instance_types" {
    description = "List of instance types for the EKS managed node group"
    type        = optional(list(string))
    default     = null
}

variable "labels" {
    description = "Labels to apply to the EKS managed node group"
    type        = optional(map(string))
    default     = {}

}

variable "taints" {
    description = "Taints to apply to the EKS managed node group"
    type        = optional(map(string))
    default     = {}
}

variable "timeouts" {
    description = "Timeouts for the EKS managed node group operations"
    type = optional(map(string), {
    create = "40m"
    delete = "1h"
    update = "1h"
  })
  default = {
    create = "40m"
    delete = "1h"
    update = "1h"  
    }     
}

variable "key_name" {
    description = "Key name for the EKS managed node group"
    type        = optional(string)
    default     = null
}   

variable "iam_role_arn_nodes" {
    description = "IAM role ARN for the EKS managed node group nodes"
    type        = optional(string)
    default     = null
}   


variable "vpc_security_group_ids" {
    description = "List of VPC security group IDs to associate with the EKS managed node group"
    type        = optional(list(string))
    default     = []
}




