
locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : length(data.aws_availability_zones.available.names)

}


resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  tags = merge(var.default_tags, {
    Name = "nat-${var.name}-${count.index}"
  })

}

resource "aws_eip" "secondary-ips-nat" {
  count = var.enable_secondary_ips_nat ? local.nat_gateway_count : 0

  tags = merge(var.default_tags, {
    Name = "nat-secondary-ips-${var.name}-${count.index}"
  })

  
}

resource "aws_nat_gateway" "nat" {
  count         = local.nat_gateway_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.eks_public_subnet[count.index].id

  tags = merge(var.default_tags, {
    Name = "nat-${var.name}-${count.index}"
  })

  secondary_allocation_ids = var.enable_secondary_ips_nat ? [aws_eip.secondary-ips-nat[count.index].id] : []

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_subnet.eks_public_subnet, aws_eip.nat,aws_eip.secondary-ips-nat
  ]
}


# resource "aws_nat_gateway_eip_association" "nat" {
#   count          = local.nat_gateway_count
#   allocation_id  = aws_eip.nat[count.index].id
#   nat_gateway_id = aws_nat_gateway.nat[count.index].id
# }
