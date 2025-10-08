

resource "aws_eks_cluster" "this" {
  name = var.name

  role_arn                  = aws_iam_role.cluster-role.arn
  version                   = var.eks_version
  enabled_cluster_log_types = var.cluster_log_types

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    subnet_ids              = aws_subnet.eks_private_subnet[*].id
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_service_ipv4cidr
    ip_family         = "ipv4"
  }


  encryption_config {
    provider {
      key_arn = lookup(var.kms_setting, "encryption_key_arn", null) != null ? lookup(var.kms_setting, "encryption_key_arn", null) : aws_kms_key.eks[0].arn

    }
    resources = ["secrets"]
  }

  upgrade_policy {
    support_type = var.upgrade_policy_type
  }


  zonal_shift_config {
    enabled = true
  }

  tags = merge(var.default_tags, {
    "name" = "${var.name}"
  })

  timeouts {
    create = lookup(var.eks_timeout, "create", null)
    delete = lookup(var.eks_timeout, "delete", null)
    update = lookup(var.eks_timeout, "update", null)
  }
}
