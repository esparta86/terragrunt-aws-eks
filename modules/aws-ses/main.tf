resource "aws_ses_domain_identity" "ses_domain" {
  count = var.enabled_module && var.enabled_domain ? 1 : 0
  domain = var.identity_domain
}

resource "aws_route53_record" "domain_identity_amazonses_verification_record" {
  count = var.enabled_module && var.enabled_domain ? 1 : 0
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "_amazonses.${var.identity_domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain[0].verification_token]
}

resource "aws_ses_domain_dkim" "dkim_domain" {
  # domain = join("",aws_ses_domain_identity.)
  count = var.enabled_module && var.enabled_domain ? 1 : 0
  domain = aws_ses_domain_identity.ses_domain[0].domain
}


#Description : Terraform code to verify domain DKIM on AWS
resource "aws_route53_record" "amazonses_dkim_record" {
  count = var.enabled_module && data.aws_route53_zone.main.zone_id != "" ? 3 : 0
  name = format("%s._domainkey.%s",element(aws_ses_domain_dkim.dkim_domain[0].dkim_tokens,count.index),var.identity_domain)
  type = "CNAME"
  zone_id = data.aws_route53_zone.main.zone_id
  records = [ format("%s.dkim.amazonses.com",element(aws_ses_domain_dkim.dkim_domain[0].dkim_tokens,count.index))]
  ttl = var.dkim_record_ttl
}


resource "aws_ses_identity_policy" "identity_policy" {
  count = var.enabled_domain && var.enabled_module ? 1 : 0
  identity = aws_ses_domain_identity.ses_domain[0].arn
  name = "identity_policy_id"
  policy = data.aws_iam_policy_document.document[0].json

}


resource "aws_sesv2_configuration_set" "configuration_ses" {
 for_each = { for config in var.configuration_ses : config.name => config }
 configuration_set_name = each.value["name"]


  dynamic "delivery_options" {
    for_each = coalesce(each.value["delivery_options"],false) ? [true] : []
    content {
      tls_policy         = try(each.value["delivery_options_values"].tls_policy,null)
      sending_pool_name  = try(each.value["delivery_options_values"].sending_pool_name,null)
    }
  }

  dynamic "reputation_options" {
    for_each = coalesce(each.value["reputation_options"],false) ? [true] :[]
    content {
      reputation_metrics_enabled = each.value["reputation_options"]
    }
  }

  sending_options {
      sending_enabled  = coalesce(each.value["sending_enabled"],true)
  }

  suppression_options {
    suppressed_reasons = length(coalesce(each.value["suppression_options"],[])) > 0 ? each.value["suppression_options"] : null
  }

  dynamic "tracking_options" {
    for_each =coalesce(each.value["tracking_options_enabled"],false) ? [true] : []
    content {
      custom_redirect_domain = try(each.value["tracking_options"],null)
    }
  }


}



resource "aws_sesv2_configuration_set_event_destination" "event_destination_ses" {
  for_each =  { for index, event in local.new_map : "${event["set_name"]}_${index}" => event  }
  configuration_set_name = each.value["set_name"]

  event_destination_name = "${each.key}"

  event_destination {

    dynamic "sns_destination" {
      for_each = each.value["sns_destination"] ? [true] : []
      content {
         topic_arn = each.value["topic_arn"]
      }
    }

    dynamic "cloud_watch_destination" {
      for_each = each.value["cloud_watch_destination"] ? [true] : []
      content {
          dimension_configuration {
            default_dimension_value = each.value["default_dimension_value"]
            dimension_name          = each.value["dimension_name"]
            dimension_value_source  = each.value["dimension_value_source"]
          }
      }
    }

    enabled              =  each.value["enabled"]
    matching_event_types =  each.value["matching_event_types"]
  }
}
