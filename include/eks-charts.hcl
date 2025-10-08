locals {

    source_base_url = "/home/esparta86/personal-development/terragrunt-aws-eks/terragrunt-aws-eks/modules/eks-charts"
    # env_vars        = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    account_vars    = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))

    aws_account_id   = local.account_vars.locals.aws_account_id
    assume_role_name = local.account_vars.locals.assume_role_name
    profile          = local.account_vars.locals.profile
    aws_region       = local.region_vars.locals.aws_region
    

}

dependency "eks" {
  config_path = find_in_parent_folders("aws-vpc-module")
}


generate "provider-local.tf" {
    path      = "provider-local.tf"
    if_exists = "overwrite_terragrunt"

    contents  = <<EOF
provider "kubernetes" {
  host = "${dependency.eks.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_ca_certificate}")

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      "${dependency.eks.outputs.cluster_name}",
      "--region",
      "${local.aws_region}",
      "--role",
      "arn:aws:iam::${local.aws_account_id}:role/${local.assume_role_name}",
    ]
  }
}
    EOF
}
