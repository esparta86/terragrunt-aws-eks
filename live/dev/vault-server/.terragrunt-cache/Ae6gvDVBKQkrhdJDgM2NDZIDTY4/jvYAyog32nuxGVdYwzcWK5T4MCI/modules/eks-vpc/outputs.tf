
output "data_subnets_private_id" {
  value = data.aws_subnets.list_private_subnets_deployment_eks_ids[*].id
}


# output "output_zonenames" {
#   value = local.zone_list
# }