output "vpc_id" {
    description = "The ID of VPC"
    value = try(aws_vpc.main_vpc.id, null)
}

output "subnets_public_ids" {
  value = aws_subnet.public_subnet[*].id
}


output "security_group_ngix_id" {
  value = aws_security_group.security_group.id
}

output "security_group_mysql_id" {
  value = aws_security_group.sg_mysql.id
}

output "subnet_private_id" {
  value = aws_subnet.private_subnet.id
}

