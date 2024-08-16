data "aws_route53_zone" "main" {
  name         = var.hosted_zone_domain
  private_zone = false
}

data "aws_iam_policy_document" "document" {
  count = var.enabled_module && var.enabled_domain ? 1 : 0
  statement {
    actions = [ "SES:SendEmail","SES:SendRawEmail" ]
    resources =  compact([ aws_ses_domain_identity.ses_domain[0].arn ])

    dynamic "principals" {
      for_each = var.principals_ses_domain_identity
      content {
        identifiers = principals.value.identifiers
        type = principals.value.type
      }

    }
  }
}
