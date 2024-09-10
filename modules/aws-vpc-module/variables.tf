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
    # "us-east-1c"
    ]
  type = list(string)
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
    "t3.medium"
    ]
  type = list(string)
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.25"
}

variable "create_db_cluster_parameter_group" {
  description = "Determines whether a cluster parameter should be created or use existing"
  type        = bool
  default     = true
}

variable "db_cluster_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other"
  type        = list(map(string))
  default     =  [{
  "name"  : "work_mem"
  "value" : 655360
  },
  {
    "name"  : "work_mem2"
    "value" : 334444}
  ]
}

variable "max_size_primary" {
  default = 2
}

variable "enable_compute_ng_default" {
 type = bool
 default = true
}

variable "list_manage_compute_ng_default" {
  type = map(any)
  default = {
      # compute_1 = {
      #     min_size     = 1
      #     max_size     = 4
      #     desired_size = 1
      #     update_config = {
      #       max_unavailable_percentage = 10
      #     }
      #     instance_types               = ["c5.4xlarge"]
      #     block_device_mappings = {
      #       xvda = {
      #         device_name = "/dev/xvda"
      #         ebs = {
      #           volume_size           = 100
      #           volume_type           = "gp3"
      #           iops                  = 3000
      #           throughput            = 150
      #           encrypted             = false
      #           delete_on_termination = true
      #         }
      #       }
      #     }
      #     labels = {
      #       "pluto.tv/service-dedicated-group" = "istio"
      #       "pluto.tv/instance-compute-type"   = true
      #       "pluto.tv/node-group"              = "compute_1"
      #     }
      #   }

      #  compute_2 = {
      #       min_size     = 0
      #       max_size     = 2
      #       desired_size = 0
      #       update_config = {
      #         max_unavailable_percentage = 10
      #       }
      #       instance_types               = ["c5.9xlarge"]
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
      #         "pluto.tv/instance-compute-type" = true
      #         "pluto.tv/node-group"            = "compute_2"

      #       }
      #       # taints = [
      #       #   {
      #       #     key    = "instance-dedicated"
      #       #     value  = "9xl"
      #       #     effect = "NO_SCHEDULE"
      #       #   }
      #       # ]
      #     }
  }
}


variable "map_roles_aws" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(any)
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
    "update" = "30m"
    "delete" = "30m"
  }
}


variable "eks_endpoint_public_cidrs" {
  type = list(string)
  default = []
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





