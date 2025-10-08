

variable "encrypted" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "lifecycle_policy" {
  type    = map(string)
  default = {}
}


variable "protection" {
  type    = bool
  default = false   
}

variable "performance_mode" {
  type    = string
  default = "generalPurpose"
}
variable "provisioned_throughput_in_mibps" {
  type    = number
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "throughput_mode" {
  type    = string
  default = "bursting"
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "create_mount_targets" {
  type    = bool
  default = false
}

variable "granular_security_groups" {
  type    = bool
  default = false
}

variable "vpc_id" {
    type = string
}

variable "availability_zone_name" {
  type    = string
}
