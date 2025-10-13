

# module "istio-core" {
#   source = "./charts-istio-core"
#   # source = "/home/esparta86/personal-development/terragrunt-aws-eks/terragrunt-aws-eks/modules/charts-istio-core"
# }


module "cluster_autoscaler" {
  source = "./cluster_autoscaler"
  # source = "/home/esparta86/personal-development/terragrunt-aws-eks/terragrunt-aws-eks/modules/eks-charts/cluster_autoscaler"

  cluster_name = var.cluster_name
  cluster_autoscaler_chart_version =  var.cluster_autoscaler_chart_version
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
  service_account_name = var.cluster_autoscaler_service_account_name
  # cluster_id   = dependency.eks.outputs.cluster_id
  # vpc_id       = dependency.eks.outputs.vpc_id
  aws_region   = "us-east-1"
  expander_priorities = {
    100 = [".*spot.*"]
    10   = [".*storage.*"]
  }
  expander_strategy = "priority"
  extra_args = {
    "scale-down-unneeded-time" = "1m" #default is 10m
    "scale-down-delay-after-add" = "5m" #default is 10m
    "scale-down-delay-after-delete" = "0s"
    "dynamic-node-delete-delay-after-taint-enabled" = true
  }
  # iam_role
  
}
