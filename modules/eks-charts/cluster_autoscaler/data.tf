data "aws_iam_policy_document" "cluster_autoscaler" {

  statement {
    sid       = "ec2WithoutConditions"
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
    ]
    resources = ["*"]

  }

  statement {
    sid    = "autoscalingConditions"
    effect = "Allow"
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
    resources = ["*"]

    dynamic "condition" {

      for_each = length(data.aws_autoscaling_groups.aws_autoscaling_groups_eks_ac_active[0].names) > 0 ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.cluster_name}"
        values   = ["owned"]
      }
    }

    dynamic "condition" {
      for_each = length(data.aws_autoscaling_groups.aws_autoscaling_groups_eks_ac_active[0].names) > 0 ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/enabled"
        values   = ["true"]
      }
    }
  }

  statement {
    sid    = "eks"
    effect = "Allow"
    actions = [
      "eks:DescribeNodegroup"
    ]
    resources = ["*"]

    dynamic "condition" {
      for_each = length(data.aws_autoscaling_groups.aws_autoscaling_groups_eks_ac_active[0].names) > 0 ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.cluster_name}"
        values   = ["owned"]
      }
    }

    dynamic "condition" {
      for_each = length(data.aws_autoscaling_groups.aws_autoscaling_groups_eks_ac_active[0].names) > 0 ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/enabled"
        values   = ["true"]
      }
    }
  }

}


data "aws_autoscaling_groups" "aws_autoscaling_groups_eks" {
  filter {
    name   = "tag:eks:cluster-name"
    values = ["${var.cluster_name}"]
  }
}


data "aws_autoscaling_groups" "aws_autoscaling_groups_eks_ac_active" {
  count = length(data.aws_autoscaling_groups.aws_autoscaling_groups_eks.names) != 0 ? 1 : 0

  filter {
    name   = "tag:k8s.io/cluster-autoscaler/${var.cluster_name}"
    values = ["owned"]
  }

  filter {
    name   = "tag:k8s.io/cluster-autoscaler/enabled"
    values = ["true"]
  }
}
