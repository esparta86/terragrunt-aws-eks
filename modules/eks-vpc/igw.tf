resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(var.default_tags, {
    Name = "igw eks"
  })
}