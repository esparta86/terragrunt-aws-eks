

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
  # extra_args = {
  #   "scale-down-unneeded-time" = "1m" #default is 10m
  #   "scale-down-delay-after-add" = "5m" #default is 10m
  #   "scale-down-delay-after-delete" = "0s"
  #   "dynamic-node-delete-delay-after-taint-enabled" = true
  # }
  # iam_role
  
}


# module "istio" {
#   source = "./istio-core"
#   environment           = var.environment
#   istiod_instance_type  = var.istiod_instance_type
#   istio_base_version    = var.istio_base_version
#   istiod_version        = var.istiod_version
#   istiod_min_replicas   = var.istiod_min_replicas
#   istio_sidecar_version = var.istio_sidecar_version
#   #istiod resources
#   cpu_requests_istiod    = var.cpu_requests_istiod
#   memory_requests_istiod = var.memory_requests_istiod
#   cluster_id             = var.cluster_id
#   region                 = var.aws_region
#   # validate_crds          = var.istio_validate_crds
#   # aws_account_id         = var.aws_account_id  
  
# }


module "aws_load_balancer_controller" {
  count = var.enable_aws_lb_controller ? 1 : 0
  source = "./aws_lb_controller"
  # source = "/home/esparta86/personal-development/terragrunt-aws-eks/terragrunt-aws-eks/modules/eks-charts/aws_lb_controller"

  cluster_name = var.cluster_name
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
  service_account_name = var.aws_load_balancer_controller_service_account_name
  # aws_region   = "us-east-1"

  # aws_lb_controller_repository       = var.aws_lb_controller_repository
  # aws_lb_controller_chart           = var.aws_lb_controller_chart 
  # aws_lb_controller_chart_version   = var.aws_lb_controller_chart_version
  # aws_lb_controller_version =   var.aws_lb_controller_version
  
  depends_on = [ module.cluster_autoscaler ]
}
