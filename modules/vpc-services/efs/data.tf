data "aws_vpc" "vpc" {
 id = var.vpc_id
}


# This data source retrieves the private subnets based on the provided VPC ID and filters.
data "aws_subnets" "private_subnets" {
  for_each =  toset(var.private_subnets) 
#   id = each.value

   filter {
        name = "vpc-id"
        values = [data.aws_vpc.vpc.id]
   }

   dynamic "filter" {
        for_each = var.availability_zone_name != null ? [1] : []
        content {
          name = "availability-zone"
          values = [var.availability_zone_name]
        }
   }

   filter {
     name = "tag:Name"
     values = ["ex-aws-vpc-module-private*"]
   }

  

  }

output "private_subnets" {
  value = data.aws_subnets.private_subnets
}
