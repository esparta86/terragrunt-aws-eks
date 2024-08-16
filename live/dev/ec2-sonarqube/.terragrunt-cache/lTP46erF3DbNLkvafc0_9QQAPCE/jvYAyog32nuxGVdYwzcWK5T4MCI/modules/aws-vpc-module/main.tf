
################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~>4.0"

  name =  local.name
  cidr =  var.vpc_cidr

  azs =  local.list_azs

  private_subnets = local.private_subnets
  public_subnets = local.public_subnets
  intra_subnets = local.intra_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
     "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.default_tags

}

################################################################################
# EKS Module
################################################################################

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "19.0"

    cluster_name = local.name
    cluster_version = var.cluster_version
    cluster_endpoint_public_access = true
    # cluster_endpoint_private_access = true

    cluster_addons = {
        coredns = {
            preserve = true
            most_recent = true

            timeouts = {
                create = "25m"
                delete = "10m"
            }
        }

        kube-proxy = {
            most_recent = true
        }

        # vpc_cni = {
        #     version="v1.13.4-eksbuild.1"
        # }

    }

    # create_kms_key = false

    cluster_encryption_config = {
        resources = ["secrets"]
        //provider_key_arn = module.kms.key_arn
        provider_key_arn = aws_kms_key.eks.arn
    }

    # iam_role_additional_policies = {
    #     additional = aws_iam_policy.additional.arn
    # }

     iam_role_additional_policies = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",aws_iam_policy.additional.arn]

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets


  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
    # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
    ingress_source_security_group_id = {
      description              = "Ingress from another computed security group"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = aws_security_group.additional.id
    }
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
    # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
    ingress_source_security_group_id = {
      description              = "Ingress from another computed security group"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = aws_security_group.additional.id
    }
  }

  eks_managed_node_group_defaults = {
    # ami_id = data.aws_ami.eks_default.image_id
    # ami_type = "CUSTOM"
    instance_types = var.worker_default_instance
    attach_cluster_primary_security_group = true
    # enable_bootstrap_user_data  = true
    # bootstrap_extra_args = "--kubelet-extra-args --node-labels node.kubernetes.io/lifecycle=spot"

    # post_bootstrap_user_data    = <<-EOT
    #   cd /tmp
    #   # To enable session manager
    #   sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    #   sudo systemctl enable amazon-ssm-agent
    #   sudo systemctl start amazon-ssm-agent
    # EOT


    metadata_options = {
      http_endpoint               = "enabled"
      http_tokens                 = "optional"
      http_put_response_hop_limit = 2
    }

    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn
    }

  }

  eks_managed_node_groups  = {
  //local.eks_managed_ng



    spot = {
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
        min_size = 2
        max_size = 2
        desired_size = 2
        capacity_type = "SPOT"
    }

    #     spotb = {
    #     ami_id = data.aws_ami.eks_default.image_id
    #     ami_type = "CUSTOM"
    #     # enable_bootstrap_user_data = true
    #     # pre_bootstrap_user_data = <<-EOT
    #     #   echo "foo"
    #     #   export FOO=bar
    #     # EOT
    #     # bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
    #     min_size = 1
    #     max_size = 1
    #     desired_size = 1
    #     capacity_type = "SPOT"
    # }

    #  spotc = {
    #     user_data_template_path = "${path.module}/templates/linux_custom.tpl"
    #     min_size = 1
    #     max_size = 1
    #     desired_size = 1
    #     capacity_type = "ON_DEMAND"
    #     pre_bootstrap_user_data = <<-EOT
    #       echo "foo"
    #       export FOO=bar
    #     EOT
    #     bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
    #     post_bootstrap_user_data    = <<-EOT
    #     cd /tmp
    #     # To enable session manager
    #     sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    #     sudo systemctl enable amazon-ssm-agent
    #     sudo systemctl start amazon-ssm-agent
    #     EOT

    #  }




#   manage_aws_auth_configmap = true

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

data "aws_ami" "eks_default" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["amazon"]
}
