locals {
   default_tags = {
    "deploy:tool"     = "terraform"
    "deploy:user"     = "lisandro"
    "cloud:provider"  = "aws"
  }
}

module "hybrik_output" {
  source      = "../s3-bucket"
  bucket_name = var.hybrik_output_name
  # force_destroy = false
  # Bucket policies
  control_object_ownership              = true
  object_ownership                      = "BucketOwnerPreferred"
  attach_policy                         = true
#   policy                                = data.aws_iam_policy_document.hybrik_output_policy.json
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  # S3 bucket-level Public Access Block configuration
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  acl                     = "private"
  tags                    = merge({ Name = var.hybrik_output_name }, local.default_tags)
  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
  lifecycle_rule = concat([
    {
      id      = "cleanup - media-validator-output"
      enabled = true
      filter = {
        prefix = "media-validator-output/"
      }
      expiration = {
        days                         = 14
        expired_object_delete_marker = false
      }
    },
    {
      id      = "cleanup - NONPROD"
      enabled = true
      filter = {
        prefix = "NONPROD/"
      }
      expiration = {
        days                         = 14
        expired_object_delete_marker = false

      }
    },
    {
      id      = "cleanup - PREPROD_BLUE"
      enabled = true
      filter = {
        prefix = "PREPROD_BLUE/"
      }
      expiration = {
        days                         = 14
        expired_object_delete_marker = false

      }
    },
    {
      id      = "cleanup - TAN_BLUE"
      enabled = true
      filter = {
        prefix = "TAN_BLUE/"
      }
      expiration = {
        days                         = 14
        expired_object_delete_marker = false

      }
    },
    {
      id      = "cleanup - workbench"
      enabled = true
      filter = {
        prefix = "workbench/"
      }
      expiration = {
        days                         = 14
        expired_object_delete_marker = false

      }
    },
  ], var.custom_life_cicle_rules)

  s3_roles = [ "arn:aws:iam::ACCOUNT_1:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS",
              "arn:aws:iam::ACCOUNT_1:role/RolePowerUserAccess",
              "arn:aws:iam::ACCOUNT_2:role/RolePowerUserAccess" ]
}
