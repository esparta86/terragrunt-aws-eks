include "root" {
  path = find_in_parent_folders("root.hcl")
}


include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}

include "eks-charts" {
  path   = find_in_parent_folders("include/eks-charts.hcl")
  expose = true
}

dependency "aws-vpc-module" {
  config_path = find_in_parent_folders("aws-vpc-module")
}


terraform {
  # source = "../../..//modules/eks-charts"
  source = include.eks-charts.locals.source_base_url

}

inputs = {
  cluster_name                            = dependency.aws-vpc-module.outputs.cluster_name
  cluster_oidc_issuer_url                 = dependency.aws-vpc-module.outputs.cluster_oidc_issuer_url
  cluster_autoscaler_service_account_name = "cluster-cus-autoscaler"
  cluster_autoscaler_chart_version        = "9.34.0" #eks 1.28 compatible
}
