

variable "hybrik_output_name" {
  description = "Name of the S3 bucket for Hybrik output."
  type        = string
}


variable "custom_life_cicle_rules" {
  description = "Custom lifecycle rules for the S3 bucket."
  type        = list(object({
    id      = string
    enabled = bool
    filter  = map(string)
    expiration = object({
      days                         = number
      expired_object_delete_marker = bool
    })
  }))
  default     = []
}
