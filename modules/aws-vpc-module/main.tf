
# ################################################################################
# # VPC Module
# ################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # version = "5.21.0"
  version = "6.1.0"
  name =  local.name
  cidr =  var.vpc_cidr
  azs =  local.list_azs
  private_subnets = local.private_subnets
  public_subnets = local.public_subnets
  # intra_subnets = local.intra_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
     "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery" = local.name
  }

  tags = merge(var.default_tags, {
    "kubernetes.io/cluster/${local.name}" = "shared"
  })

  default_network_acl_ingress = []
  manage_default_network_acl = false

}
locals {

  map_efs_addon = var.enable_efs_csi_driver ? {
    "efs-csi-driver" = {
            addon_version = var.efs_csi_driver_addon_version 
            preserve = true
            most_recent = true
            timeouts = {
                create = "25m"
                delete = "10m"
            }
            service_account_role_arn = "${aws_iam_role.efs_csi_role[0].arn}"
    }
  } : {}

  map_ebs_addon = var.enable_ebs_csi_driver ? {
    "aws-ebs-csi-driver" = {
        addon_version = "v1.42.0-eksbuild.1"
        preserve = true
        most_recent = true
        timeouts = {
            create = "25m"
            delete = "10m"
        }
        service_account_role_arn = "${aws_iam_role.ebs_csi_role[0].arn}"
    }
  } : {}
  
}
# ################################################################################
# # EKS Module
# ################################################################################

module "eks" {
    count = var.create_eks ? 1 : 0
    source  = "terraform-aws-modules/eks/aws"
    version = "21.00.0"

    name = local.name
    kubernetes_version  = var.cluster_version
    endpoint_public_access  = true
    # cluster_endpoint_private_access = true

    security_group_tags = var.cluster_sg_tags
    node_security_group_tags = var.cluster_sg_tags
    # authentication_mode = "CONFIG_MAP"

    addons = merge({
        coredns = {
            # addon_version = "v1.11.4-eksbuild.14"
            # preserve = true
            # most_recent = true

            timeouts = {
                create = "10m"
                delete = "10m"
                update = "10m"
            }
        }

        kube-proxy = {
            addon_version = "v1.28.15-eksbuild.31"
            # most_recent = true
        }

        vpc-cni = {
          #  preserve = true
          #  most_recent = true
          before_compute = true
          addon_version = "v1.19.6-eksbuild.7"
           timeouts = {
             create = "25m"
             delete = "10m"
           }
          # No required so far
          #  configuration_values = jsonencode({
          #     "enableNetworkPolicy": "true",
          #     "nodeAgent": {
          #         "healthProbeBindAddr": "8163",
          #         "metricsBindAddr": "8162"
          #     }
          #   })
        }

        # aws-ebs-csi-driver ={
        #    preserve = true
        #    most_recent = true
        #    timeouts = {
        #      create = "25m"
        #      delete = "10m"
        #    }
        #    service_account_role_arn = "${aws_iam_role.ebs_csi_role.arn}"

        # }

        # aws-efs-csi-driver = {
        #     preserve = true
        #     most_recent = true
        #     timeouts = {
        #         create = "25m"
        #         delete = "10m"
        #     }
        #     service_account_role_arn = "${aws_iam_role.efs_csi_role[0].arn}"
        # }




    },local.map_efs_addon, local.map_ebs_addon)

    create_kms_key = false
    iam_role_use_name_prefix  = true

    # Version 20.0.0 BREAKING CHANGES
    # manage_aws_auth_configmap = true
    # aws_auth_roles = var.map_roles_aws


    encryption_config = {
        resources = ["secrets"]
        //provider_key_arn = module.kms.key_arn
        provider_key_arn = aws_kms_key.eks.arn
    }

    timeouts = {
      create = lookup(var.eks_timeout,"create",null)
      update = lookup(var.eks_timeout,"update",null)
      delete = lookup(var.eks_timeout,"delete",null)
    }

    # iam_role_additional_policies = {
    #     additional = aws_iam_policy.additional.arn
    # }

    # iam_role_additional_policies = {
    #   "AmazonEBSCSIDriverPolicy" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #   }# ,aws_iam_policy.additional.arn]

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    endpoint_public_access_cidrs = var.eks_endpoint_public_cidrs

    enable_cluster_creator_admin_permissions = true
  security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
    # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
    # ingress_source_security_group_id = {
    #   description              = "Ingress from another computed security group"
    #   protocol                 = "tcp"
    #   from_port                = 22
    #   to_port                  = 22
    #   type                     = "ingress"
    #   source_security_group_id = aws_security_group.additional.id
    # }
  }


    # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    ingress_15017 = {
      description = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
      protocol = "TCP"
      from_port = 15017
      to_port = 15017
      type = "ingress"
      source_cluster_security_group = true
    }

    ingress_15012 = {
      description                   = "Cluster API to nodes ports/protocols"
      protocol                      = "TCP"
      from_port                     = 15012
      to_port                       = 15012
      type                          = "ingress"
      source_cluster_security_group = true
    }

    # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
    # ingress_source_security_group_id = {
    #   description              = "Ingress from another computed security group"
    #   protocol                 = "tcp"
    #   from_port                = 22
    #   to_port                  = 22
    #   type                     = "ingress"
    #   source_security_group_id = aws_security_group.additional.id
    # }
  }

  #Deprecated since version 21.0.0
  # eks_managed_node_group_defaults = {
  #   # ami_id = data.aws_ami.eks_default.image_id
  #   # ami_type = "CUSTOM"
  #   # ami_type = "AL2_x86_64"
  #   # ami_type = "AL2023_x86_64_STANDARD"
  #   platform = "al2023"
  #   # user_data_type = "linux"
  #   instance_types = var.worker_default_instance
  #   attach_cluster_primary_security_group = true
  #   # enable_bootstrap_user_data  = true
  #   # bootstrap_extra_args = "--kubelet-extra-args --node-labels node.kubernetes.io/lifecycle=spot"

  #   # post_bootstrap_user_data    = <<-EOT
  #   #   cd /tmp
  #   #   # To enable session manager
  #   #   sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  #   #   sudo systemctl enable amazon-ssm-agent
  #   #   sudo systemctl start amazon-ssm-agent
  #   # EOT


  #   metadata_options = {
  #     http_endpoint               = "enabled"
  #     http_tokens                 = "required"
  #     http_put_response_hop_limit = 1
  #   }

  #   # iam_role_additional_policies = {
  #   #   additional = aws_iam_policy.additional.arn
  #   # }

  # }

  eks_managed_node_groups  = {
  //local.eks_managed_ng

    spot0 = {
        name = "spot0"
        min_size = 1
        max_size = 6
        desired_size = 1
        capacity_type = "SPOT"
        instance_types = ["t3.small"]

        labels = {
          "colocho/GroupNode" = "spot0"
          "colocho/instanceType"    = "t3.small"
        }
        tags = {
          "kubernetes.io/cluster/${local.name}" = "owned"
          "k8s.io/cluster-autoscaler/${local.name}" = "owned"
          "k8s.io/cluster-autoscaler/enabled" = "true"
        }        
    }

    # spot2 = {
    #     min_size = 1
    #     max_size = 2
    #     desired_size = 1
    #     capacity_type = "SPOT"
    #     labels = {
    #       "colocho/service" = "servicea"
    #       "colocho/type"    = "compute_1"
    #       "type"
    #     }

    #     taints = [
    #       {
    #         key   = "dedicated"
    #         value = "gpuGroup"
    #         effect = "NO_SCHEDULE"
    #       }
    #     ]
    # }
    # spot = {
        # pre_bootstrap_user_data = <<-EOT
        # #!/bin/bash
        # set -ex
        # cat <<-EOF > /etc/profile.d/bootstrap.sh
        #   export KUBELET_EXTRA_ARGS="--node-labels=node.kubernetes.io/lifecycle=spot "
        # EOF
        #   sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
        # EOT
        # enable_bootstrap_user_data = true
        # pre_bootstrap_user_data = <<-EOT
        #   echo "foo"
        #   export FOO=bar
        # EOT
        # bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
        # platform = "al2023"
        # ami_type = "AL2023_x86_64_STANDARD"
        # name = "spot"
        # min_size = 2
        # max_size = 5
        # desired_size = 2
        # capacity_type = "SPOT"
        # instance_types = ["t3.small"]
        

        # cloudinit_pre_nodeadm = [
        #   {
        #     content_type = "application/node.eks.aws"
        #     content      = <<-EOT
        #       ---
        #       apiVersion: node.eks.aws/v1alpha1
        #       kind: NodeConfig
        #       spec:
        #         kubelet:
        #           config:
        #             shutdownGracePeriod: 30s
        #             featureGates:
        #               PersistentVolumeLastPhaseTransitionTime: false
        #     EOT
        #   }
        # ]
        # labels = {
        #   "colocho/GroupNode" = "Compute1"
        #   "colocho/instanceType"    = "t3.small"
        # }
        # tags = {
        #   "kubernetes.io/cluster/${local.name}" = "owned"
        #   "k8s.io/cluster-autoscaler/${local.name}" = "owned"
        #   "k8s.io/cluster-autoscaler/enabled" = "true"
        # }
        # taints = [
        #   {
        #     key   = "dedicated"
        #     value = "gpuGroup"
        #     effect = "NO_SCHEDULE"
        #   }
        # ]
        # create_iam_role          =  true #default true
        # iam_role_name            = "spot-eks-node-group"
        # iam_role_use_name_prefix = true

    #         iam_role_additional_policies = {
    #   additional = aws_iam_policy.additional.arn
    # }

    #  }

    # storage = {
 
    #     platform = "al2023"
    #     ami_type = "AL2023_x86_64_STANDARD"
    #     min_size = 1
    #     max_size = 5
    #     desired_size = 1
    #     capacity_type = "SPOT"
    #     instance_types = ["t2.small"]

    #     labels = {
    #       "colocho/GroupNode" = "Compute2"
    #       "colocho/instanceType"    = "t2.small"          
    #     }

    #     tags = {
    #       "k8s.io/cluster-autoscaler/${local.name}" = "owned"
    #       "k8s.io/cluster-autoscaler/enabled" = "true"
    #     }        
    # }
       
    
  #   spot2 = {
  #     min_size = 1
  #     max_size = 1
  #     desired_size =1
  #     capacity_type = "SPOT"

  #     labels = {
  #       Environment = "nonprd"
  #       nodeGroupName = "spot2"
  #     }

  #   }

  #   #     spotb = {
  #   #     ami_id = data.aws_ami.eks_default.image_id
  #   #     ami_type = "CUSTOM"
  #   #     # enable_bootstrap_user_data = true
  #   #     # pre_bootstrap_user_data = <<-EOT
  #   #     #   echo "foo"
  #   #     #   export FOO=bar
  #   #     # EOT
  #   #     # bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
  #   #     min_size = 1
  #   #     max_size = 1
  #   #     desired_size = 1
  #   #     capacity_type = "SPOT"
  #   # }

  #   #  spotc = {
  #   #     user_data_template_path = "${path.module}/templates/linux_custom.tpl"
  #   #     min_size = 1
  #   #     max_size = 1
  #   #     desired_size = 1
  #   #     capacity_type = "ON_DEMAND"
  #   #     pre_bootstrap_user_data = <<-EOT
  #   #       echo "foo"
  #   #       export FOO=bar
  #   #     EOT
  #   #     bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
  #   #     post_bootstrap_user_data    = <<-EOT
  #   #     cd /tmp
  #   #     # To enable session manager
  #   #     sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  #   #     sudo systemctl enable amazon-ssm-agent
  #   #     sudo systemctl start amazon-ssm-agent
  #   #     EOT

  #   #  }





  # #  aws_auth_roles = var.map_roles_aws

   }


}



# module "kms" {
#   source  = "terraform-aws-modules/kms/aws"
#   version = "~> 1.5"

#   aliases               = ["eks/${local.name}"]
#   description           = "${local.name} cluster encryption key"
#   enable_default_policy = true
#   key_owners            = [data.aws_caller_identity.current.arn]

#   tags = var.default_tags
# }


resource "aws_kms_key" "eks" {
  description             = "EKS secret key for ${local.name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# data "aws_ami" "eks_default" {
#   filter {
#     name   = "name"
  #     values = ["amazon-eks-node-${var.cluster_version}-v*"]
#   }

#   most_recent = true
#   owners      = ["amazon"]
# }



 module "eks-auth" {
  count = var.create_eks ? 1 : 0
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.5.0"

  manage_aws_auth_configmap = true
  aws_auth_roles = var.map_roles_aws
  depends_on = [ module.eks ]

 }
