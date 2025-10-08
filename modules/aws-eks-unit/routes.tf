

# There are as many route tables as the numbers of NAT Gateways
# If single_nat_gateway is true, only one route table will be created with a single NAT
# If single_nat_gateway is false, one route table will be created per availability zone

resource "aws_route_table" "private" {
  count  = local.nat_gateway_count
  vpc_id = aws_vpc.this.id


  # route {
  #     cidr_block = "0.0.0.0/0"
  #     nat_gateway_id = aws_nat_gateway.nat[count.index].id
  # }
  tags = merge(var.default_tags, {
    Name = "private-route-table-${var.name}"
  })

}

resource "aws_route" "private" {
  count = local.nat_gateway_count

  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
  destination_cidr_block = "0.0.0.0/0"

}

# unlike private route tables, there is only one public route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.default_tags, {
    Name = "public-route-table-${var.name}"
  })

}


resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table_association" "private-route-table" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.eks_private_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id

}


resource "aws_route_table_association" "public-route-table" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.eks_public_subnet[count.index].id
  route_table_id = aws_route_table.public.id

}
