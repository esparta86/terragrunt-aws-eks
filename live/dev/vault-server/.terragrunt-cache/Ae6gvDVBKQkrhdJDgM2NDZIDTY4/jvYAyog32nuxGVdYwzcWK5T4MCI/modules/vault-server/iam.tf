resource "aws_iam_instance_profile" "vault-server" {
    name = "vault-server-instance-profile"
    role = aws_iam_role.vault-server-role.name
}

resource "aws_iam_role" "vault-server-role" {
    name = "vault-server-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}



data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role_policy" "vault-server" {
    policy = data.aws_iam_policy_document.vault-server.json
    name = "${var.environment_name}-vault-server-policy"
    role = aws_iam_role.vault-server-role.id
}


data "aws_iam_policy_document" "vault-server" {
  statement {
      sid = "ec2"
      effect = "Allow"
      actions = [ "ec2:DescribeInstances" ]
      resources = [ "*" ]
}

  statement {
    sid = "VaultAuthAWSMethod"
    effect = "Allow"
    actions = [
        "ec2:DescribeInstances",
        "iam:GetInstanceProfile",
        "iam:GetUser",
        "iam:GetRole"
    ]
    resources = [ "*" ]
  }


  statement {
    sid = "VaultKMSUnseal"
    effect = "Allow"
    actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:DescribeKey"
     ]
     resources = [ "*" ]
  }


}

# ----------

# locals {
#   account =
# }

data "aws_iam_policy_document" "vault-primary-policy" {

  statement {
      sid = "ec2"
      effect = "Allow"
      actions = [ "ec2:DescribeInstances" ]
      resources = [ "*" ]
}

  statement {
      sid = "iam"
      effect = "Allow"
      actions = [
        "iam:GetInstanceProfile",
        "iam:GetUser",
        "iam:GetRole"
        ]
      resources = [ "*" ]
}

  statement {
      sid = "sts"
      effect = "Allow"
      actions = [
        "sts:GetFederationToken"
        ]
      resources = [ "*" ]
}


  statement {
      sid = "ManageOwnAccessKeys"
      effect = "Allow"
      actions = [
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:GetAccessKeyLastUsed",
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey"
        ]
      resources = [ "arn:aws:iam::*:user/${var.environment_name}-vault-user" ]
}

  statement {
      sid = "stsAssume"
      effect = "Allow"
      actions = [
        "sts:AssumeRole"
        ]
    #   resources = [ for account in var.external_aws : "arn:aws:iam::${account}:role/trust-relationship-for-primary-aws-and-vault" ]
       resources = [ for ikey,ivalue in var.external_aws : "arn:aws:iam::${ivalue.account}:role/trust-relationship-for-primary-aws-and-vault" ]
}




}


resource "aws_iam_user" "vault" {
    name = "${var.environment_name}-vault-user"
}

resource "aws_iam_user_policy" "user-policy" {
  name = "user-policy"
  user = aws_iam_user.vault.name
  policy = data.aws_iam_policy_document.vault-primary-policy.json
}

resource "aws_iam_access_key" "access-key" {
    user = aws_iam_user.vault.name
}

output "secret-iam-user" {
  sensitive = true
  value = aws_iam_access_key.access-key.secret
}



# ------------------------------------ resources second account

data "aws_iam_policy_document" "secondary" {

 for_each = { for acc in var.external_aws : acc.account => acc }
    provider = aws.aws2
  statement {
      sid = "ec2"
      effect = "Allow"
      actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole" ]
      resources = [ "*" ]
   }
}


