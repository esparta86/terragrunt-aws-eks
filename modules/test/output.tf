# output "subnets_public_ids" {
#   value = data.aws_subnets.list_private_subnets_redis.ids
# }


# output "aws_elasticache_replication_group_existing" {
#     value = data.aws_elasticache_replication_group.existing_cluster.id
# }

# output "unused_subnets" {
#     value = [ for s in data.aws_subnet.unused_subnets : s.id ]
# }

output "aws_ec2_instance_type_offerings-locations" {
value = data.aws_ec2_instance_type_offerings.example.locations
}

output "aws_ec2_instance_type_offerings" {
value = {
      TYPES = data.aws_ec2_instance_type_offerings.example.instance_types
      LOCATION = data.aws_ec2_instance_type_offerings.example.locations
  }
}


# output "aws_ec2_instance_type_offerings_for" {
#     value = [ for s in data.aws_ec2_instance_type_offerings.example.locations : s.id ]
# }

output "aws_data_vpc" {
  value = data.aws_vpc.vpc.id
}

output "datasubnets-public" {
  value = data.aws_subnets.subnetmain_public.ids
}

output "datasubnets-private" {
  value = data.aws_subnets.subnetmain_private.ids
}


output "subnetpublic-information" {
  # value = [
  #   for s in data.aws_subnet.public-subnets : s.cidr_block
  # ]

  value = data.aws_subnet.public-subnets
}

output "list" {

   value = [for s in local.mergelist : upper(s) ]
}