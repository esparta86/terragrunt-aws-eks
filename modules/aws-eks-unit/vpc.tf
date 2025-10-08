
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.default_tags, {
    Name = "vpc-${var.name}"
  })

}


resource "aws_subnet" "eks_private_subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, count.index + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.default_tags, {
    "Name"                              = "eks-private-subnet-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/${var.name}" = "owned"
    "tier"                              = "Private"
    "eks"                               = "deployment"
  })
}


resource "aws_subnet" "eks_public_subnet" {

  depends_on = [
    aws_vpc.this, aws_subnet.eks_private_subnet
  ]

  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  # We can not use just cidrsubnet(var.development_vpc_cidr, 8, count.index + 1) because it will produce an overlapping 
  # the CIDR Block have to start in the next jump from the last CIDR used by the eks_private subnets
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, length(aws_subnet.eks_private_subnet) + count.index + 1)
  tags = merge(var.default_tags, {
    "Name"                              = "eks-public-subnet-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/demo"        = "owned"
    "tier"                              = "Public"
    "eks"                               = "deployment"
    "kubernetes.io/cluster/${var.name}" = "shared"
  })

}
