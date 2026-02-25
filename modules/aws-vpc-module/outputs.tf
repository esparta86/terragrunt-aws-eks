output "private_subnets_cidrrange" {
  value = local.private_subnets
}

output "available_zones" {
  value = local.list_azs
}

output "public_subnets_cidrrange" {
  value = local.public_subnets
}

# output "intra_subnets_cidrrange" {
#   value = local.intra_subnets
# }

# output "eks_managed_ng" {
#    value = local.eks_managed_ng
# }


output "aws_caller_identity" {
 value = data.aws_caller_identity.current
}


output "aws_iam_session_context" {
  value = data.aws_iam_session_context.current
}


output "cluster_name" {
  value = try(module.eks[0].cluster_name,"no-eks-cluster")
}

output "cluster_endpoint" {
  value = try(module.eks[0].cluster_endpoint,"no-eks-cluster-endpoint")
}

output "cluster_oidc_issuer_url" {
  value = try(module.eks[0].cluster_oidc_issuer_url,"no-eks-cluster-oidc-issuer-url")
  
}

output "cluster_dualstack_oidc_issuer_url" {
  value = try(module.eks[0].cluster_dualstack_oidc_issuer_url,"no-eks-cluster-oidc-issuer-url")
  
}

output "cluster_ca_certificate" {
  value = try(module.eks[0].cluster_certificate_authority_data,"no-eks-cluster-ca-certificate")
}


output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}


output "manage_nde_groups" {
  value = module.eks[0].eks_managed_node_groups
}
