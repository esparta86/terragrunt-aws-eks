

# resource "aws_s3_bucket" "s3_without_policy" {
#     bucket = "s3-without-allow-policy"
    
# }

# resource "aws_s3_bucket_policy" "deny_acccess" {
#     bucket = aws_s3_bucket.s3_without_policy.id
#     policy = data.aws_iam_policy_document.deny_access_notadmin.json
# }


# data "aws_iam_policy_document" "deny_access_notadmin" {
#   statement {
#     not_principals {
#       type = "AWS"
#       identifiers = [ "arn:aws:iam::AWS_ACCOUNT:user/lisandroR" ]
#     }

#     actions = [ "s3:GetObject" ]
#     effect = "Deny"
#     resources = [ "${aws_s3_bucket.s3_without_policy.arn}/*" ]
#   }

#   statement {
#     principals {
#       type = "AWS"
#       identifiers = [ "arn:aws:iam::AWS_ACCOUNT:user/lisandroR" ]
#     }

#     actions = [ "s3:*" ]
#     effect = "Allow"
#     resources = [ "${aws_s3_bucket.s3_without_policy.arn}/*" ]
#     # condition {
#     #   test = "StringEquals"
#     #   variable = "s3:ExistingObjectTag/access"
#     #   values = [ "secret","hidden" ]
#     # }
#   }



#   depends_on = [ aws_s3_bucket.s3_without_policy ]

# }

# locals {
#     excludedCRDs = [
#     "wasmplugins.extensions.istio.io",
#     "destinationrules.networking.istio.io",
#     "envoyfilters.networking.istio.io",
#     "gateways.networking.istio.io",
#     "proxyconfigs.networking.istio.io",
#     "serviceentries.networking.istio.io",
#     "sidecars.networking.istio.io",
#     "virtualservices.networking.istio.io",
#     "workloadentries.networking.istio.io",
#     "workloadgroups.networking.istio.io",
#     "authorizationpolicies.security.istio.io",
#     "peerauthentications.security.istio.io",
#     "requestauthentications.security.istio.io",
#     "telemetries.telemetry.istio.io",
#   ]

#   version_parts =  split(".", var.istio_base_version)
#  exclude_crds = tonumber(local.version_parts[0]) >= 1 && tonumber(local.version_parts[1]) >=24 && length(local.excludedCRDs) > 0

# }

# output "values" {
#   value = [yamlencode(merge({
#     "global" : {
#       "hub" : "HUB"
#     }
#     }, tonumber(local.version_parts[1]) >= 1 && tonumber(local.version_parts[2]) >= 24 && length(local.excludedCRDs) > 0 ? {
#     "base" : {
#       "excludedCRDs" : local.excludedCRDs
#     }
#   } : {}))]
# }

# output "exclude_crds" {
#   value = local.exclude_crds
# }



