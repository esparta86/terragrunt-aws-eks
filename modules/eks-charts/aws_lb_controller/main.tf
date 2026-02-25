
module "iam_assumable_role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"

   create_role = true
   role_name   = "aws-lb-controller-${var.cluster_name}"
   provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
   role_policy_arns = [
    aws_iam_policy.aws_load_balancer_controller_1.arn,
    aws_iam_policy.aws_load_balancer_controller_2.arn
   ]
   oidc_fully_qualified_subjects = [
     "system:serviceaccount:kube-system:${var.service_account_name}"
   ]

   depends_on = [ aws_iam_policy.aws_load_balancer_controller_1, 
   aws_iam_policy.aws_load_balancer_controller_2 ]

}

resource "aws_iam_policy" "aws_load_balancer_controller_1" {
  name_prefix = "aws_load_balancer_controller"
  description = "EKS aws_load_balancer_controller policy for cluster ${var.cluster_name}"
  policy      =  file("${path.module}/policy1.json")
}


resource "aws_iam_policy" "aws_load_balancer_controller_2" {
  name_prefix = "aws_load_balancer_controller"
  description = "EKS aws_load_balancer_controller policy for cluster ${var.cluster_name}"
  policy      =  file("${path.module}/policy2.json")
}





resource "helm_release" "aws_lb_controller" {
  name             = "aws-load-balancer-controller"
  namespace        = "kube-system"
  repository       = var.aws_lb_controller_repository
  chart            = var.aws_lb_controller_chart
  version          = var.aws_lb_controller_chart_version
  create_namespace = true
  atomic = true

  values =  [yamlencode({
    "image" : {
      "tag" : var.aws_lb_controller_version
    },
    "podLabels" : {
      "team-name" : "colocho",
      "tags.datadoghq.com/env" : var.environment,
      "tags.datadoghq.com/service" : "aws-load-balancer-controller",
      "tags.datadoghq.com/version" : var.aws_lb_controller_version
    },
    "annotations" : {
      "prometheus.io/port" : "8080",
      "prometheus.io/scrape" : "true"
    },
    "clusterName" : var.cluster_name,
    "serviceAccountName" : "${var.service_account_name}",
    "serviceAccount" : {
      "create" : true,
      "annotations" : {
        "eks.amazonaws.com/role-arn" : "${module.iam_assumable_role_admin.iam_role_arn}"
      }
    }
  })]
}
