

resource "aws_s3_bucket" "s3_without_policy" {
    bucket = "s3-without-allow-policy"
    
}

resource "aws_s3_bucket_policy" "deny_acccess" {
    bucket = aws_s3_bucket.s3_without_policy.id
    policy = data.aws_iam_policy_document.deny_access_notadmin.json
}


data "aws_iam_policy_document" "deny_access_notadmin" {
  statement {
    not_principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::734237051973:user/lisandroR" ]
    }

    actions = [ "s3:GetObject" ]
    effect = "Deny"
    resources = [ "${aws_s3_bucket.s3_without_policy.arn}/*" ]
  }

  statement {
    principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::734237051973:user/lisandroR" ]
    }

    actions = [ "s3:*" ]
    effect = "Allow"
    resources = [ "${aws_s3_bucket.s3_without_policy.arn}/*" ]
    # condition {
    #   test = "StringEquals"
    #   variable = "s3:ExistingObjectTag/access"
    #   values = [ "secret","hidden" ]
    # }
  }



  depends_on = [ aws_s3_bucket.s3_without_policy ]

}
