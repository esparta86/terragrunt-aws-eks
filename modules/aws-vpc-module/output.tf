output "private_subnets_cidrrange" {
  value = local.private_subnets
}

output "available_zones" {
  value = local.list_azs
}

output "public_subnets_cidrrange" {
  value = local.public_subnets
}

output "intra_subnets_cidrrange" {
  value = local.intra_subnets
}

# output "eks_managed_ng" {
#    value = local.eks_managed_ng
# }
