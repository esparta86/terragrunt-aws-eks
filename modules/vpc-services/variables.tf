

variable "map_efs" {
    type = list(object({
      name = string
      availability_zone_name = optional(string, null)
      encrypted = optional(bool, false)
      kms_key_id = optional(string, null)
      lifecycle_policy = optional(map(string),null)
      protection = optional(bool, false)
      performance_mode = optional(string, "generalPurpose")
      provisioned_throughput_in_mibps = optional(number, null)
      tags = optional(map(string), {})
      throughput_mode = optional(string, "bursting")
      create_mount_targets = optional(bool, false)
      granular_security_groups = optional(bool, false)
    }))
}

variable "private_subnets" {
    type = list(string)
    default = []
}


variable "vpc_id" {
    type = string
}


