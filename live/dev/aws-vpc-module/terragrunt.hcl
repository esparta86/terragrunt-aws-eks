terraform {
    source = "../../..//modules/aws-vpc-module"
}

inputs = {
  vpc_name = "main-colocho"
  vpc_cidr = "10.0.0.0/16"
  enable_compute_ng_default = false
  cluster_version = "1.29"

  cluster_sg_tags = {
    "kubernetes.io/cluster/ex-aws-vpc-module" = null
    "karpenter.sh/discovery" = "ex-aws-vpc-module"
  }

  map_roles_aws = [
    {
      rolearn = "arn:aws:iam::734237051973:role/RolePowerColocho"
      username = "admin-colocho"
      groups = ["system:masters"]
    },
    {
      rolearn = "arn:aws:iam::734237051973:role/KarpenterNodeRole-ex-aws-vpc-module"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = ["system:bootstrappers","system:nodes"]
    }
  ]
  eks_endpoint_public_cidrs = ["201.247.242.51/32"]


  # conf_resp_headers_policy_enable_cors = false
  # conf_resp_headers_policy_enable_cors_access_ctrl_allow_cred = true
  # map_cors_conf = {
  #   "access_control_allow_headers" = ["item1","item2"]
  #   "access_control_allow_methods" = ["item1","item2"]
  #   "access_control_allow_origins" = ["item1","item2"]
  # }
  # conf_resp_headers_policy_enable_cors_origin_override = true

  # custom_headers_config = [
  #   {
  #     header = "X-Permitted-Cross-Domain-Policies"
  #     override = true
  #     value = "non2e"
  #   },

  #   {
  #     header = "X-Test"
  #     override = true
  #     value = "non2e"

  #   }
  # ]

  # security_headers_config = {
  #   content_type_options = {
  #       override = true
  #   }

  #   frame_options = {
  #     frame_option = "DENY"
  #     override     = true
  #   }

  #   referrer_policy = {
  #       referrer_policy = "same-origin"
  #       override = true
  #   }

  #   xss_protection = {
  #     mode_block = true
  #     protection = true
  #     overwrite  = true
  #     report_uri = "URI"
  #   }

  #   strict_transport_security  = {
  #     access_control_max_age_sec = "63072000"
  #     include_subdomains         = true
  #     preload                    = true
  #     override                   = true
  #   }

  #   content_security_policy = {
  #     content_security_policy  = "STRING"
  #     override   = true
  #   }

  # }

  # cache_parameters_behaviour = {

  #     cookie_behavior = "whitelist"
  #     # cookies_items = ["example"]
  #     query_string_behavior = "whitelist"
  #     # query_items = ["example"]
  #     header_behavior = "whitelist"
  #     # header_items    = ["example"]
  # }

  # cache_parameters_items = {
  #   cookies_items   = ["example"]
  #   query_items     = ["example"]
  #   header_items = ["example"]
  # }

}

include {
    path = find_in_parent_folders()
}
