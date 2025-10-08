# resource "aws_iam_policy" "additional" {
#   name = "${local.name}-additional"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:Describe*",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }


#  policy document to create a role and granting AssumeRoleWithWebIdentity

data "aws_iam_policy_document" "ebs_csi_assume_role_policy" {
  count = var.enable_ebs_csi_driver && var.create_eks ? 1 : 0
    statement {
      actions = [ "sts:AssumeRoleWithWebIdentity" ]
      effect = "Allow"

      condition {
        test = "StringEquals"
        # variable = "${replace(module.eks.cluster_oidc_issuer_url,"https://","")}:sub"
        variable = "${module.eks[0].oidc_provider}:sub"
        values = [ "system:serviceaccount:kube-system:ebs-csi-controller-sa" ]
      }

      principals {
        identifiers = [ module.eks[0].oidc_provider_arn ]
        type = "Federated"
      }
    }

}


resource "aws_iam_role" "ebs_csi_role" {
  count = var.enable_ebs_csi_driver ? 1 : 0
    assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy[0].json
    name = "AmazonEKS_EBS_CSI_DriverRole"
}


locals {
  list_ebs_csi_roles = length(var.list_ebs_csi_roles) > 0 && var.enable_ebs_csi_driver ? var.list_ebs_csi_roles : []
}


resource "aws_iam_role_policy_attachment" "ebs_csi_attachment" {
  for_each = {
    for policy_arn in toset(local.list_ebs_csi_roles): basename(policy_arn) => policy_arn
  }
  policy_arn = each.value
  role = aws_iam_role.ebs_csi_role[0].name
}


#IRSA FOR EFS CSI DRIVER

data "aws_iam_policy_document" "efs_assume_role_policy" {
  count = var.enable_efs_csi_driver && var.create_eks ? 1 : 0
    statement {
      actions = [ "sts:AssumeRoleWithWebIdentity" ]
      effect = "Allow"

      condition {
        test = "StringEquals"
        # variable = "${replace(module.eks.cluster_oidc_issuer_url,"https://","")}:sub"
        variable = "${module.eks[0].oidc_provider}:sub"
        values = [ "system:serviceaccount:kube-system:efs-csi-controller-sa" ]
      }

      principals {
        identifiers = [ module.eks[0].oidc_provider_arn ]
        type = "Federated"
      }
    }
  
}

resource "aws_iam_role" "efs_csi_role" {
  count = var.enable_efs_csi_driver ? 1 : 0
  name = "AmazonEKS_EFS_CSI_DriverRole"
  assume_role_policy = data.aws_iam_policy_document.efs_assume_role_policy[0].json
}

locals {
  list_efs_csi_roles  = length(var.list_efs_csi_roles) > 0 &&  var.enable_efs_csi_driver ? var.list_efs_csi_roles : []
}

resource "aws_iam_role_policy_attachment" "efs_csi_attachment" {
  for_each = {
    for policy_arn in toset(local.list_efs_csi_roles): basename(policy_arn) => policy_arn
  }
  policy_arn = each.value
  role       = aws_iam_role.efs_csi_role[0].name

  depends_on = [ 
    aws_iam_role.efs_csi_role
  ]
}
# resource "aws_iam_policy" "ebs_csi_iam_policy" {
#     policy = jsonencode({
#         Statement = [{
#           Effect = "Allow"
#         }]
#         Version = "2012-10-17"
#     })
# }



# --------------------------------------------------------------

