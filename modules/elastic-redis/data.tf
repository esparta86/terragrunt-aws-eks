

# data "aws_elasticache_replication_group" "existing_cluster" {
#     replication_group_id  = aws_elasticache_replication_group.this.id
# }


# data "aws_subnets" "list_private_subnets_existing" {

#     filter {
#        name = "vpc-id"
#        values = [ aws_vpc.vpc.id ]
#     }
# }


# data "aws_subnets" "list_private_subnets_existing" {
#   depends_on = [
#     aws_vpc.vpc, aws_subnet.private_subnets
#   ]

#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.vpc.id]
#   }

#   filter {
#     name   = "tag:purpose"
#     values = ["Redis"]
#   }

#   filter {
#     name   = "tag:tier"
#     values = ["Private"]
#   }

#   filter {
#     name = "availability-zone"
#     values = var.redis_availability_zones_second
#   }
# }



# data "aws_subnet" "unused_subnets" {
#     for_each = toset(data.aws_subnets.list_private_subnets_existing.ids)
#     id = each.value
#     # filter {
#     #   name = "subnet-id"
#     #   values = [ each.key ]
#     # }

#     depends_on = [ data.aws_subnets.list_private_subnets_existing ]
# }




# data "aws_subnet" "unused_subnets" {
#   filter {
#     name   = "availability-zone"
#     values =  var.redis_availability_zones_second
#   }
# }