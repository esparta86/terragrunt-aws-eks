
module "iam_assumable_role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

   create_role = true
   role_name   = "eks-cluster-autoscaler-${var.cluster_name}"
   provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
   role_policy_arns = [
    aws_iam_policy.cluster_autoscaler.arn,
   ]
   oidc_fully_qualified_subjects = [
     "system:serviceaccount:kube-system:${var.service_account_name}"
   ]

   depends_on = [ aws_iam_policy.cluster_autoscaler ]

}


resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}
