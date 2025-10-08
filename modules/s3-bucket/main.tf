module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.11.0"

  bucket = var.bucket_name

  force_destroy       = var.force_destroy
  acceleration_status = var.acceleration_status
  request_payer       = var.request_payer

  tags = var.tags

  # Note: Object Lock configuration can be enabled only on new buckets
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration

  object_lock_enabled       = var.object_lock_enabled
  object_lock_configuration = var.object_lock_configuration

  # Bucket policies

  attach_policy                         = var.attach_policy
  policy                                =  data.aws_iam_policy_document.allow_read[0].json
  attach_deny_insecure_transport_policy = var.attach_deny_insecure_transport_policy
  attach_require_latest_tls_policy      = var.attach_require_latest_tls_policy

  # S3 bucket-level Public Access Block configuration

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # S3 Bucket Ownership Controls
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls

  control_object_ownership = var.control_object_ownership
  object_ownership         = var.object_ownership

  expected_bucket_owner = var.expected_bucket_owner

  acl = var.acl

  logging = var.logging

  versioning = var.versioning

  website = var.website

  server_side_encryption_configuration = var.server_side_encryption_configuration

  cors_rule = var.cors_rule

  lifecycle_rule = var.lifecycle_rule

  intelligent_tiering = var.intelligent_tiering
}

resource "aws_s3_object" "directory_structure" {
  for_each = toset(var.s3_folders)

  bucket       = module.s3_bucket.s3_bucket_id
  key          = "${each.value}/"
  content_type = "application/x-directory"
}


data "aws_iam_policy_document" "allow_read" {
  count = length(var.s3_roles) > 0 ? 1 : 0

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
      "arn:aws:s3:::${var.bucket_name}"
    ]

    principals {
      type        = "AWS"
      identifiers = var.s3_roles
    }
  }

  # depends_on = [ module.s3_bucket ]
  
}

# resource "aws_s3_bucket_policy" "allow_read_policy" {
#   count = length(var.s3_roles) > 0 ? 1 : 0
#   bucket = module.s3_bucket.s3_bucket_id
#   policy = data.aws_iam_policy_document.allow_read[0].json
  
# }
