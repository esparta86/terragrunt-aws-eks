
variable "hosted_zone_domain" {
  type = string
  description = " zone domain "
}


variable "identity_domain" {
  type = string
  default = "preprd.esparta86.com"
  description = "subdomain or domain "
}

variable "enabled_domain" {
  type = bool
  default = true
  description = "Enable domain instead email"
}


variable "enabled_module" {
  type = bool
  default = true
}

variable "dkim_record_ttl" {
  type = string
  default = "600"
}

variable "principals_ses_domain_identity" {
  type = list(object({
    type = string
    identifiers = list(string)
  }))

  default = [ {
    "type" = "AWS"
    "identifiers" = ["*"]
  }

  ]
}


variable "configuration_ses" {
  type = list(object({
    name = string
    delivery_options = optional(bool)
    delivery_options_values = optional(map(string))
    reputation_options = optional(bool)
    sending_enabled = optional(bool)
    suppression_options = optional(list(string))
    tracking_options = optional(string)
    tracking_options_enabled = optional(bool)
    event_destination = optional(list(object({
      cloud_watch_destination = optional(bool)
      dimension_configuration = optional(map(string))
      enabled                 = bool
      matching_event_types    = list(string)
      sns_destination         = optional(bool)
      topic_arn               = optional(string)
    })))
  }))

  default = [
    {
    name = "first_configuration"
    delivery_options = true
    delivery_options_values = {
      tls_policy = "REQUIRE"
      sending_pool_name = "ses-default-dedicated-pool"
    }
    reputation_options = false
    sending_enabled = true
    suppression_options = ["BOUNCE","COMPLAINT"]
    tracking_options_enabled = true
    tracking_options = "pluto.esparta86.com"

    event_destination = [
      {
        cloud_watch_destination = true
        dimension_configuration = {
          default_dimension_value = "example"
          dimension_name          = "example"
          dimension_value_source  = "MESSAGE_TAG"
        }
        enabled = true
        matching_event_types = ["SEND"]
       },
       {
        sns_destination = true
        topic_arn = "arn:aws:sns:us-east-1:734237051973:ses_topic_first_configuration"
        enabled = true
        matching_event_types = ["SEND"]
       }
     ]
  },
  #   {
  #   name = "second_configuration"
  #   delivery_options = true
  #   delivery_options_values = {
  #     tls_policy = "REQUIRE"
  #     sending_pool_name = "ses-default-dedicated-pool"
  #   }
  #   reputation_options = false
  #   sending_enabled = true
  #   # suppression_options = ["BOUNCE","COMPLAINT"]
  #   tracking_options_enabled = true
  #   tracking_options = "pluto.esparta86.com"

  #   event_destination = [
  #     {
  #       cloud_watch_destination = true
  #       dimension_configuration = {
  #         default_dimension_value = "example"
  #         dimension_name          = "example"
  #         dimension_value_source  = "MESSAGE_TAG"
  #       }
  #       enabled = true
  #       matching_event_types = ["SEND","REJECTS"]
  #      },
  #      {
  #       sns_destination = true
  #       topic_arn = "arn:aws:sns:us-east-1:734237051973:ses_topic_first_configuration"
  #       enabled = true
  #       matching_event_types = ["SEND"]
  #      }
  #    ]
  # },

  ]
}
