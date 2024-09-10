output "vpc_account_a_id" {
    description = "The ID of VPC"
    value = try(aws_vpc.main_vpc.id, null)
}

output "vpc_account_b_id" {
    description = "The ID of VPC"
    value = try(aws_vpc.main_vpc2[0].id, null)
}

output "subnets_public_account_a_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "subnets_public_account_b_ids" {
  value = aws_subnet.public_subnet2[*].id
}

output "subnet_private_1_account_a_id" {
  value = aws_subnet.private_subnet[0].id
}

output "subnet_private_2_account_a_id" {
  value = aws_subnet.private_subnet2[0].id
}


output "subnet_private_1_account_b_id" {
  value = try(aws_subnet.private_subnet3[0].id,null)
}

output "subnet_private_2_account_b_id" {
  value = try(aws_subnet.private_subnet4[0].id,null)
}
# output "security_group_ngix_id" {
#   value = aws_security_group.security_group.id
# }

# output "security_group_mysql_id" {
#   value = aws_security_group.sg_mysql[0].id
# }

# output "subnet_private_id" {
#   value = aws_subnet.private_subnet[0].id
# }

# output "subnet_private_id2" {
#   value = aws_subnet.private_subnet2[0].id
# }

# output "route_nat1" {
#   value = local.route_nat1
# }
