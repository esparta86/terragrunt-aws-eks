data "aws_iam_policy" "ssm_managed_instance_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAppStreamPCAAccess"
}



resource "aws_iam_role_policy_attachment" "ssm_managed_instance_role" {
  for_each   = toset(compact(flatten([for group in var.eks_managed_node_groups : coalesce(group.iam_role_name, []) ])))
  role       = each.key
  policy_arn = data.aws_iam_policy.ssm_managed_instance_policy.arn
}
