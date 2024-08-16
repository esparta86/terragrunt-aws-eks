variable "environment" {
  type = string
}

variable "redis_name" {
  type = string
}

variable "cluster_mode_enabled" {
  type = bool
  default = false
}

variable "number_cache_clusters" {
  description = "AWS ElastiCache Redis replicas for non cluster version"
  type        = number
  default     = 0
}

variable "tags" {
  type        = map(any)
}

variable "redis_node_type" {
  description = "Type of nodes used for redis"
  type        = string
}

variable "redis_port" {
  description = "AWS ElastiCache Redis port"
  type        = number
  default     = 6379
}

variable "redis_version" {
  description = "AWS ElastiCache Redis version"
  type        = string
}

variable "automatic_failover_enabled" {
  type        = bool
  default     = false
}

variable "redis_num_node_groups" {
  description = "AWS ElastiCache Redis number of node groups"
  type        = number
  default     = 1
}

variable "redis_replicas" {
  description = "Number of AWS ElastiCache Redis replicas"
  type        = number
  default     = 0
}

variable "redis_parameter_group_family" {
  description = "Provides an AWS ElastiCache Redis parameter group"
  type        = string
}

variable "redis_parameters" {
  description = "A list of Redis parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}


variable "whitelist_cidr_blocks" {
  description = "List of CIDR blocks which can access the Redis"
  type        = list(any)
  default     = []
}

variable "security_group_ids" {
  description = "List of Security Groups which can access the Redis"
  type        = list(any)
  default     = []
}


variable "vpc_cidr" {
  description = "cidr for eks vpc"
  type = string
  default = "10.0.0.0/16"
}



variable "redis_availability_zones" {
  description = "List of Availability zones deploy Redis to"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

// SECOND



# variable "redis_name_second" {
#   type = string
# }

# variable "cluster_mode_enabled_second" {
#   type = bool
#   default = false
# }

# variable "number_cache_clusters_second" {
#   description = "AWS ElastiCache Redis replicas for non cluster version"
#   type        = number
#   default     = 0
# }


# variable "redis_node_type_second" {
#   description = "Type of nodes used for redis"
#   type        = string
# }

# variable "redis_port_second" {
#   description = "AWS ElastiCache Redis port"
#   type        = number
#   default     = 6379
# }

# variable "redis_version_second" {
#   description = "AWS ElastiCache Redis version"
#   type        = string
# }

# variable "automatic_failover_enabled_second" {
#   type        = bool
#   default     = false
# }

# variable "redis_num_node_groups_second" {
#   description = "AWS ElastiCache Redis number of node groups"
#   type        = number
#   default     = 1
# }

# variable "redis_replicas_second" {
#   description = "Number of AWS ElastiCache Redis replicas"
#   type        = number
#   default     = 0
# }

# variable "redis_parameter_group_family_second" {
#   description = "Provides an AWS ElastiCache Redis parameter group"
#   type        = string
# }

# variable "redis_parameters_second" {
#   description = "A list of Redis parameters to apply"
#   type = list(object({
#     name  = string
#     value = string
#   }))
#   default = []
# }




# variable "tags_second" {
#   type        = map(any)
# }

# variable "redis_availability_zones_second" {
#   description = "List of Availability zones deploy Redis to"
#   type        = list(any)
#   default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
# }