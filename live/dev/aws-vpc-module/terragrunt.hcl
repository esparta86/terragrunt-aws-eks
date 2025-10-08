include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}


include "eks" {
  path   = find_in_parent_folders("include/eks.hcl")
  expose = true
}

# include "eks" {
#   path = "${get_repo_root()}/include/eks.hcl"
#   expose = true
# }


terraform {

  source = include.eks.locals.source_base_url
}




inputs = {
  module_name = basename(get_original_terragrunt_dir())
  tg_map = {
    "tg_dir" = get_terragrunt_dir()
    # "tg_parent_dir" = get_parent_terragrunt_dir()
    "tg_repo_root" = get_repo_root()
  }



  aws_account_id            = local.aws_account_id
  vpc_name                  = "main-colocho"
  vpc_cidr                  = "10.0.0.0/16"
  enable_compute_ng_default = false

  cluster_version = "1.28"
  create_eks      = true

  enable_ebs_csi_driver = true
  enable_efs_csi_driver = false

  cluster_sg_tags = {
    "kubernetes.io/cluster/ex-aws-vpc-module" = null
    "karpenter.sh/discovery"                  = "ex-aws-vpc-module"
  }

  map_roles_aws = [
    {
      rolearn  = "arn:aws:iam::${local.aws_account_id}:role/RolePowerColocho"
      username = "admin-colocho"
      groups   = ["system:masters"]
    },
    # {
    #   rolearn = "arn:aws:iam::${local.aws_account_id}:role/spot-eks-node-group-20250331203140551000000002"
    #   username = "system:node:{{EC2PrivateDNSName}}"
    #   groups = ["system:bootstrappers","system:nodes"]
    # }    
    # {
    #   rolearn = "arn:aws:iam::${local.aws_account_id}:role/KarpenterNodeRole-ex-aws-vpc-module"
    #   username = "system:node:{{EC2PrivateDNSName}}"
    #   groups = ["system:bootstrappers","system:nodes"]
    # }
  ]
  eks_endpoint_public_cidrs = ["131.226.33.35/32","179.5.94.197/32"]



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

   node-group-custom-types = {
      storage_1 = {
        name           = "storage_1"
        min_size       = 2
        max_size       = 4
        desired_size   = 2
        instance_types = ["t3.small"]
        labels = {
          "marte.tv/instance-storage-type" = true
          "marte.tv/node-group"            = "storage_1"
        }
        taints = {
          # storage_1 = {
          #   key    = "marte.tv/node-group"
          #   value  = "storage_1"
          #   effect = "NO_SCHEDULE"
          # }
        }
        # metadata_options = local.metadata_options
      }
    }


}
