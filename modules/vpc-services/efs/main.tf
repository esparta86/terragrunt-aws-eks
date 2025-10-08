

resource "aws_efs_file_system" "this" {
#   count = var.enable_efs_csi_driver ? 1 : 0
  availability_zone_name = var.availability_zone_name != null ? var.availability_zone_name : null
  # region =  var.availability_zone_name == null ? "us-east-1" : null
#   creation_token = "${var.name}-efs"
  performance_mode = var.performance_mode
  encrypted = var.encrypted
  kms_key_id = var.kms_key_id

  dynamic "lifecycle_policy" { 
    for_each = var.lifecycle_policy != null ? [true] : []
    content {
      transition_to_ia = lookup(var.lifecycle_policy,"transition_to_ia",null)
      transition_to_archive = lookup(var.lifecycle_policy,"transition_to_archive",null)
      transition_to_primary_storage_class = lookup(var.lifecycle_policy,"transition_to_primary_storage_class",null)
      }
  }

  dynamic "protection" {
    content {
        replication_overwrite = "ENABLED"
    }
    for_each = var.protection ? [true] : []
  }

  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode = var.throughput_mode
  tags = var.tags
    
}




resource "aws_efs_mount_target" "this" {
#   for_each = var.create_mount_targets ? toset(var.private_subnets) : []
  for_each = var.create_mount_targets ? toset(flatten([ for s in data.aws_subnets.private_subnets : s.ids ])) : []
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = each.value
  # Important: Ensure that the security group allows ingress on port 2049 for NFS
  # Important to define sg because the rule for inbound traffic is defined in the security group
  # using the default sg of vpc is not recommended
  security_groups = !var.granular_security_groups ? [ aws_security_group.allow_efs_ingress[0].id ] : null
  # depends_on = [ aws_security_group.allow_efs_ingress ]
}


# granular_security_groups = false by default, so the security group is created only once
resource "aws_security_group" "allow_efs_ingress" {
  count = var.granular_security_groups ? 0 : 1

  name        = "Allow_efs_ingress"
  description = "Allow EFS ingress for ${aws_efs_file_system.this.name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [ data.aws_vpc.vpc.cidr_block ]
  }

#   tags = merge(var.tags, { Name = "${var.name}-efs-ingress" })
}

# resource "aws_security_group" "allow_efs_ingress_granular" {
#    for_each = var.create_mount_targets && var.granular_security_groups ? toset(flatten([ for s in data.aws_subnets.private_subnets : s.ids ])) : []

#   name        = "Allow_efs_ingress"
#   description = "Allow EFS ingress for ${aws_efs_file_system.this.name}"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 2049
#     to_port     = 2049
#     protocol    = "tcp"
#     cidr_blocks = [ data.aws_subnets.private_subnets[each.value].cidr_blocks ]
#   }
# }
