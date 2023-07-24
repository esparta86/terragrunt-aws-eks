output "subnets_public_ids" {
  value = data.aws_subnets.list_private_subnets_redis.ids
}


# output "aws_elasticache_replication_group_existing" {
#     value = data.aws_elasticache_replication_group.existing_cluster.id
# }

# output "unused_subnets" {
#     value = [ for s in data.aws_subnet.unused_subnets : s.id ]
# }