variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "vpc_name" {
  description = "name for vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "The availability zones to spread nodes in"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    # "us-east-1e",
    "us-east-1f"
  ]
  type = list(string)
}

variable "create_eks" {
  description = "Determines whether an EKS cluster should be created or use existing"
  type        = bool
  default     = true
}



variable "default_tags" {
  default = {
    cloudprovider = "aws"
    owner         = "devops-team"
    Terraform     = "true"
    Environment   = "development"
  }
  description = "Default tags name to tag in resources"
  type        = map(string)
}

variable "worker_default_instance" {
  description = "The availability zones to spread nodes in"
  default = [
    # "c5n.2xlarge"
    "t3.small",
  ]
  type = list(string)
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.31"
}

variable "create_db_cluster_parameter_group" {
  description = "Determines whether a cluster parameter should be created or use existing"
  type        = bool
  default     = true
}

variable "db_cluster_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other"
  type        = list(map(string))
  default = [{
    "name" : "work_mem"
    "value" : 655360
    },
    {
      "name" : "work_mem2"
    "value" : 334444 }
  ]
}

variable "max_size_primary" {
  default = 2
}

variable "enable_compute_ng_default" {
  type    = bool
  default = true
}

# locals {
#   base_node_groups = {
#     compute_1 = {
#       min_size     = 0
#       max_size     = 2
#       desired_size = 0
#       update_config = {
#         max_unavailable_percentage = 10
#       }
#       instance_types        = ["t3.small"]
#       create_security_group = true
#       iam_role_additional_policies = {
#         "AmazonEBSCSIDriverPolicy" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#       }
#       block_device_mappings = {
#         xvda = {
#           device_name = "/dev/xvda"
#           ebs = {
#             volume_size           = 100
#             volume_type           = "gp3"
#             iops                  = 3000
#             throughput            = 150
#             encrypted             = false
#             delete_on_termination = true
#           }
#         }
#       }
#       labels = {
#         "colocho86/instance-compute-type" = true
#         "colocho86/node-group"            = "compute_1"
#       }
#     }

#     memory_1 = {
#       min_size     = 0
#       max_size     = 2
#       desired_size = 0
#       update_config = {
#         max_unavailable_percentage = 10
#       }
#       instance_types        = ["t3.small"]
#       create_security_group = false
#       iam_role_additional_policies = {
#         "AmazonEBSCSIDriverPolicy" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#       }
#       block_device_mappings = {
#         xvda = {
#           device_name = "/dev/xvda"
#           ebs = {
#             volume_size           = 100
#             volume_type           = "gp3"
#             iops                  = 3000
#             throughput            = 150
#             encrypted             = false
#             delete_on_termination = true
#           }
#         }
#       }
#       labels = {
#         "colocho86/instance-memory-type" = true
#         "colocho86/node-group"           = "memory_1"
#       }
#     }


#   }
# }

# variable "node_group_overrides" {
#   description = "A map of node group overrides to customize node groups"
#   type        = map(any)
#   default     = {}
# }

variable "node_group_overrides" {
  description = "Map of EKS managed node group definitions to create"
  type = map(object({
    min_size                       = optional(number)
    max_size                       = optional(number)
    desired_size                   = optional(number)
    ami_id                         = optional(string)
    ami_type                       = optional(string)
    ami_release_version            = optional(string)
    instance_types                 = optional(list(string))
    labels                         = optional(map(string))
    update_config = optional(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
    }))
    block_device_mappings = optional(map(object({
      device_name = optional(string)
      ebs = optional(object({
        delete_on_termination      = optional(bool)
        encrypted                  = optional(bool)
        iops                       = optional(number)
        kms_key_id                 = optional(string)
        snapshot_id                = optional(string)
        throughput                 = optional(number)
        volume_initialization_rate = optional(number)
        volume_size                = optional(number)
        volume_type                = optional(string)
      }))
      no_device    = optional(string)
      virtual_name = optional(string)
    })))
    iam_role_additional_policies  = optional(map(string))
    # Security group
    create_security_group                 = optional(bool)
  }))
  default = {}
}

variable "base_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type = map(object({
    min_size                       = optional(number)
    max_size                       = optional(number)
    desired_size                   = optional(number)
    ami_id                         = optional(string)
    ami_type                       = optional(string)
    ami_release_version            = optional(string)
    instance_types                 = optional(list(string))
    labels                         = optional(map(string))
    update_config = optional(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
    }))
    block_device_mappings = optional(map(object({
      device_name = optional(string)
      ebs = optional(object({
        delete_on_termination      = optional(bool)
        encrypted                  = optional(bool)
        iops                       = optional(number)
        kms_key_id                 = optional(string)
        snapshot_id                = optional(string)
        throughput                 = optional(number)
        volume_initialization_rate = optional(number)
        volume_size                = optional(number)
        volume_type                = optional(string)
      }))
      no_device    = optional(string)
      virtual_name = optional(string)
    })))
    iam_role_additional_policies  = optional(map(string))
    # Security group
    create_security_group                 = optional(bool)
  }))
  default = {
    compute_1 = {
      min_size     = 0
      max_size     = 2
      desired_size = 0
      update_config = {
        max_unavailable_percentage = 10
      }
      instance_types        = ["t3.small"]
      create_security_group = true
      iam_role_additional_policies = {
        "AmazonEBSCSIDriverPolicy" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = false
            delete_on_termination = true
          }
        }
      }
      labels = {
        "colocho86/instance-compute-type" = true
        "colocho86/node-group"            = "compute_1"
      }
    }

    memory_1 = {
      min_size     = 0
      max_size     = 2
      desired_size = 0
      update_config = {
        max_unavailable_percentage = 10
      }
      instance_types        = ["t3.small"]
      create_security_group = false
      iam_role_additional_policies = {
        "AmazonEBSCSIDriverPolicy" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = false
            delete_on_termination = true
          }
        }
      }
      labels = {
        "colocho86/instance-memory-type" = true
        "colocho86/node-group"           = "memory_1"
      }
    }
  }

}


variable "map_roles_aws" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type        = list(any)
  # type = list(object({
  #   rolearn  = string
  #   username = string
  #   groups   = list(string)
  # }))

  # default = [ {
  #   "key" =
  # } ]
}

variable "cluster_sg_tags" {
  type = map(any)
}

variable "eks_timeout" {
  type = map(string)
  default = {
    "create" = "30m"
    "update" = "60m"
    "delete" = "15m"
  }
}


variable "eks_endpoint_public_cidrs" {
  type    = list(string)
  default = []
}

variable "list_ebs_csi_roles" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}

variable "list_efs_csi_roles" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"]
}


### CORS configuration block ###
# variable "conf_resp_headers_policy_enable_cors" {
#   type = bool
#   default = false
# }

# variable "conf_resp_headers_policy_enable_cors_access_ctrl_allow_cred"{
#   type = bool
#   default = false
# }

# variable "map_cors_conf" {
#   type = map(list(string))
#   default = {
#     "access_control_allow_headers" = []
#     "access_control_allow_methods" = []
#     "access_control_allow_origins" = []
#   }
# }

# variable "conf_resp_headers_policy_enable_cors_origin_override" {
#   default = false
#   type = bool
# }


# ### Custom header config ###


# variable "custom_headers_config"{
#   type = list(map(string))
#   default = []
# }


# ### Security headers config ###

# variable "security_headers_config" {
#   type = map(any)
#   default = {}
# }


# ### cloudfront cache policy ###

# variable "cache_policy_ttl" {
#   type = map(number)
#   description = "map of ttls"
#   default = {
#     "default_ttl" = 3600
#     "max_ttl"  = 86400
#     "min_ttl"  = 60
#   }
# }

# variable "cache_parameters_behaviour" {
#   type = map(string)
#   default = {}
# }

# variable "cache_parameters_items" {
#    type = map(list(string))
#    default = {
#    }
# }





variable "istio_core_chart" {
  type    = string
  default = "base"
}

variable "istio_core_repository" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_core_version" {
  type    = string
  default = "1.20.7"
}



variable "istio_base_repository" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_base_chart" {
  type    = string
  default = "base"
}

variable "istio_base_version" {
  type = string
  #default = "1.12.7"
  default = "1.17.8"
}

variable "istio_base_canary_version" {
  type = string
  #default = "1.12.7"
  default = "1.18.0"
}

variable "image_hub" {
  type        = string
  description = "Image repository"
  default     = "gcr.io/istio-release"
}

variable "istiod_repository" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istiod_chart" {
  type    = string
  default = "istiod"
}
variable "istiod_version" {
  type    = string
  default = "1.17.8"
}

variable "istiod_canary_version" {
  type    = string
  default = "1.18.0"
}

variable "istiod_min_replicas" {
  type    = string
  default = "2"
}

variable "istiod_instance_type" {
  type    = string
  default = "t3.medium"
}


variable "cpu_requests_istiod" {
  type        = string
  description = "cpu requests for istiod"
  default     = "0.5"
}

variable "memory_requests_istiod" {
  type        = string
  description = "memory requests for istiod"
  default     = "1Gi"
}

variable "team_name" {
  type        = string
  description = "name of the service team"
  default     = "team-infra"
}


variable "service_account_aws_alb" {
  type        = string
  description = "Name of the k8s service account"
  default     = "aws-load-balancer-controller"
}


variable "aws_lb_controller_chart" {
  type        = string
  description = "Helm chart name for aws_lb_controller"
  default     = "aws-load-balancer-controller"
}

variable "aws_lb_controller_chart_version" {
  type        = string
  description = "Helm chart version for aws_lb_controller"
  default     = "1.6.2"
}

variable "aws_lb_controller_version" {
  type        = string
  description = "aws_lb_controller docker version"
  default     = "v2.6.2"
}

variable "aws_lb_controller_repository" {
  type        = string
  description = "Helm chart repository for aws_lb_controller"
  default     = "https://aws.github.io/eks-charts"
}

variable "enable_efs_csi_driver" {
  type        = bool
  description = "Enable EFS CSI driver"
  default     = true
}

variable "efs_csi_driver_addon_version" {
  type        = string
  description = "EFS CSI driver addon version"
  default     = "v1.6.0-eksbuild.1"
}


variable "enable_ebs_csi_driver" {
  type        = bool
  description = "Enable EBS CSI driver"
  default     = true
}


variable "module_name" {
  type        = string
  description = "Name of the module"
}

variable "tg_map" {
  type        = map(string)
  description = "Map of terragrunt directories"
}


variable "node-group-custom-types" {
  type        = map(any)
  description = "values for node groups with different custom types"
  default     = {}
}
