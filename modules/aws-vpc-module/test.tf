# resource "aws_cloudfront_response_headers_policy" "default" {
#   name    = "example-policy"
#   comment = "test comment"

#   dynamic "cors_config" {
#     for_each = var.conf_resp_headers_policy_enable_cors ? [true] : []
#     content {

#     access_control_allow_credentials = var.conf_resp_headers_policy_enable_cors_access_ctrl_allow_cred
#     access_control_allow_headers {
#       items = lookup(var.map_cors_conf,"access_control_allow_headers",[])
#     }
#     access_control_allow_methods {
#       items = lookup(var.map_cors_conf,"access_control_allow_methods",[])
#     }
#     access_control_allow_origins {
#       items = lookup(var.map_cors_conf,"access_control_allow_origins",[])
#     }
#     origin_override = var.conf_resp_headers_policy_enable_cors_origin_override
#     }
#   }

# dynamic "custom_headers_config" {
#   for_each = length(var.custom_headers_config) > 0 ? [true] : []
#   content {

#     dynamic "items" {
#       for_each = var.custom_headers_config
#       content {
#         header   = items.value.header
#         override = items.value.override
#         value    = items.value.value
#       }

#     }

#   }

# }

# dynamic "security_headers_config" {
#   for_each = length(var.security_headers_config) > 0 ? [true] : []

#   content {

#     dynamic content_type_options {
#       for_each = contains(keys(var.security_headers_config),"content_type_options") ? [true] : []
#       content {
#         override = lookup(var.security_headers_config.content_type_options,"override",false)
#       }
#     }

#     dynamic "referrer_policy" {
#       for_each = contains(keys(var.security_headers_config),"referrer_policy") ? [true]:[]
#       content {
#         override = lookup(var.security_headers_config.referrer_policy,"override",false)
#         referrer_policy = lookup(var.security_headers_config.referrer_policy,"referrer_policy","")
#       }
#     }

#     dynamic "frame_options" {
#       for_each = contains(keys(var.security_headers_config),"frame_options") ? [true]:[]
#       content {
#         override      = lookup(var.security_headers_config.frame_options,"override",false)
#         frame_option  = lookup(var.security_headers_config.frame_options,"frame_option","")
#       }
#     }

#     dynamic "xss_protection" {
#       for_each = contains(keys(var.security_headers_config),"xss_protection") ? [true]:[]
#       content {
#         override      = lookup(var.security_headers_config.xss_protection,"override",false)
#         protection    = lookup(var.security_headers_config.xss_protection,"protection",false)
#         mode_block    = lookup(var.security_headers_config.xss_protection,"mode_block",false)
#         report_uri    = lookup(var.security_headers_config.xss_protection,"mode_block",false) ? null: lookup(var.security_headers_config.xss_protection,"report_uri",false)
#       }

#     }

#     dynamic "strict_transport_security" {
#       for_each = contains(keys(var.security_headers_config),"strict_transport_security") ? [true]:[]
#       content {
#         access_control_max_age_sec = lookup(var.security_headers_config.strict_transport_security,"access_control_max_age_sec","0")
#         override = lookup(var.security_headers_config.strict_transport_security,"override",false)
#         include_subdomains = lookup(var.security_headers_config.strict_transport_security,"include_subdomains",false)
#         preload =  lookup(var.security_headers_config.strict_transport_security,"preload",false)
#       }
#     }

#     dynamic "content_security_policy" {
#       for_each = contains(keys(var.security_headers_config),"content_security_policy") ? [true]:[]
#       content {
#         content_security_policy = lookup(var.security_headers_config.content_security_policy,"content_security_policy","")
#         override = lookup(var.security_headers_config.content_security_policy,"override",false)
#       }

#     }


#   }
# }


# }



# resource "aws_cloudfront_cache_policy" "default"{
# name = "command-center-cache-policy"
# comment = " Cahce policy for"

# default_ttl = lookup(var.cache_policy_ttl,"default_ttl",3600)
# max_ttl = lookup(var.cache_policy_ttl,"max_ttl",86400)
# min_ttl = lookup(var.cache_policy_ttl,"min_ttl",60)

#  parameters_in_cache_key_and_forwarded_to_origin {

#     cookies_config {
#       cookie_behavior = lookup(var.cache_parameters_behaviour,"cookie_behavior","")
#       cookies {
#         items = lookup(var.cache_parameters_items,"cookies_items",[])
#       }
#     }

#     query_strings_config {
#       query_string_behavior = lookup(var.cache_parameters_behaviour,"query_string_behavior","")
#       query_strings {
#         items = lookup(var.cache_parameters_items,"query_items",[])
#       }
#     }

#      headers_config {
#       header_behavior = lookup(var.cache_parameters_behaviour,"header_behavior","")
#       headers {
#         items = lookup(var.cache_parameters_items,"header_items",[])
#       }
#     }
#  }

# }
