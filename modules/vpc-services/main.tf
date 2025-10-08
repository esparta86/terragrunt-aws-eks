
module "efs" {
  source = "./efs"
  count = length(var.map_efs)
  performance_mode = lookup(element(var.map_efs, count.index),"performance_mode", "generalPurpose")
  encrypted = lookup(element(var.map_efs, count.index),"encrypted", false)
  kms_key_id = lookup(element(var.map_efs, count.index),"kms_key_id", null)
  lifecycle_policy = lookup(element(var.map_efs, count.index),"lifecycle_policy", {})
  protection = lookup(element(var.map_efs, count.index),"protection", false)
  provisioned_throughput_in_mibps = lookup(element(var.map_efs, count.index),"provisioned_throughput_in_mibps", null)
  tags = lookup(element(var.map_efs, count.index),"tags", {})
  throughput_mode = lookup(element(var.map_efs, count.index),"throughput_mode", "bursting")

  private_subnets = var.private_subnets
  create_mount_targets = lookup(element(var.map_efs, count.index),"create_mount_targets", false)
  granular_security_groups = lookup(element(var.map_efs, count.index),"granular_security_groups", false)
  availability_zone_name = lookup(element(var.map_efs, count.index),"availability_zone_name", null)
  
  vpc_id = var.vpc_id
}
