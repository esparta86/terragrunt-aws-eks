
resource "aws_kms_key" "eks" {
  count = lookup(var.kms_setting, "encryption_key_arn", null) != null ? 0 : 1

  description             = "KMS key for EKS cluster encryption, clustername: ${var.name}"
  deletion_window_in_days = lookup(var.kms_setting, "kms_deletion_window_in_days", 7)
  enable_key_rotation     = lookup(var.kms_setting, "enable_key_rotation", true)

  tags = merge(var.default_tags, {
    Name = "eks-kms-key-${var.name}"
  })

}
