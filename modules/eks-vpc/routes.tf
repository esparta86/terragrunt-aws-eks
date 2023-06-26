

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.eks_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = merge(var.default_tags, {
    Name = "route-private"
    })

}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.default_tags, {
    Name = "route-public"
  })

}

# Route table Association with private Subnet's
# We are going to use the same route for all subnets.
resource "aws_route_table_association" "privateRTassociation" {
  count          = length(data.aws_availability_zones.available_zones.names)
  subnet_id      = element(aws_subnet.eks_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}




# Route table Association with public Subnet's
# We are going to use the same route for all subnets.
resource "aws_route_table_association" "publicRTassociation" {
  count          = length(data.aws_availability_zones.available_zones.names)
  subnet_id      = element(aws_subnet.eks_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}