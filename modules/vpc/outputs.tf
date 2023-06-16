output "vpc_id" {
    description = "The ID of VPC"
    value = try(aws_vpc.main_vpc.id, null)
}

output "subnets_public_ids" {
  value = aws_subnet.public_subnet[*].id
}