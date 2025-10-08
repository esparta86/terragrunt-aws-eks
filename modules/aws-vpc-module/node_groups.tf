# module "custom_eks_managed_node_group" {
#   source   = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#   for_each = var.create_eks ? var.node-group-custom-types : {}
#   version  = "20.37.1"

#   name            = each.value.name
#   cluster_name    = local.name
#   cluster_version = var.cluster_version
#   subnet_ids      = module.vpc.private_subnets

#   // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
#   // Without it, the security groups of the nodes are empty and thus won't join the cluster.
#   cluster_primary_security_group_id = module.eks[0].cluster_primary_security_group_id
#   vpc_security_group_ids            = [module.eks[0].node_security_group_id]

#   min_size     = each.value.min_size
#   max_size     = each.value.max_size
#   desired_size = each.value.desired_size

#   update_config = {
#     max_unavailable_percentage = 5
#   }
#   instance_types   = each.value.instance_types
#   labels           = each.value.labels
#   taints           = each.value.taints
#   cluster_service_cidr = module.eks[0].cluster_service_cidr

#   tags = {
#       "kubernetes.io/cluster/${local.name}" = "owned"
#       "k8s.io/cluster-autoscaler/enabled"   = "true"
#       "k8s.io/cluster-autoscaler/${local.name}" = "owned"
#     }
  

#   #   pre_bootstrap_user_data = <<-EOT
#   #   #!/bin/bash
#   #   set -e

#   #   # NVMe device for i4i.4xlarge (typically /dev/nvme1n1)
#   #   DEVICE="/dev/nvme1n1"
#   #   MOUNT_DIR="/mnt/instance-store"

#   #   # Check if device exists
#   #   if [ ! -b "$DEVICE" ]; then
#   #     echo "ERROR: Device $DEVICE not found!"
#   #     exit 1
#   #   fi

#   #   # Format if not already formatted
#   #   if ! blkid "$DEVICE" >/dev/null; then
#   #     mkfs -t ext4 "$DEVICE"
#   #   fi

#   #   # Create mount directory
#   #   mkdir -p "$MOUNT_DIR"

#   #   # Mount device
#   #   mount "$DEVICE" "$MOUNT_DIR"

#   #   # Add to fstab (persist across reboots)
#   #   echo "$DEVICE $MOUNT_DIR ext4 defaults,nofail 0 2" >> /etc/fstab

#   #   # Verify
#   #   df -hT "$MOUNT_DIR"
#   #   echo "NVMe storage mounted at $MOUNT_DIR"
#   # EOT
# #   create = false
# #   metadata_options = each.value.metadata_options
# #   tags             = var.tags
# }
