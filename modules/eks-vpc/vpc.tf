
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.eks_vpc_cidr
  tags = merge(var.default_tags,{
    Name = "eks-vpc"
  })
}



resource "aws_subnet" "eks_private_subnet" {
  count = length(data.aws_availability_zones.available_zones.names)

  vpc_id = aws_vpc.eks_vpc.id
  availability_zone = element(data.aws_availability_zones.available_zones.names,count.index)
  cidr_block = cidrsubnet(var.eks_vpc_cidr,8,count.index+1)

  tags = merge(var.default_tags, {
    "Name" = "eks-private-subnet-${count.index}-${element(data.aws_availability_zones.available_zones.names,count.index)}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    "tier"                            = "Private"
    "eks"                             = "deployment"
  })

  depends_on = [ aws_vpc.eks_vpc, data.aws_availability_zones.available_zones]
}


# We are using data sources to know how many subnets has been created so far
# To create new public subnets is required to know the total subnets
# related to deployment eks and private tag

data "aws_subnets" "list_private_subnets_deployment_eks_ids" {
  depends_on = [ aws_vpc.eks_vpc, aws_subnet.eks_private_subnet ]

  filter {
    name = "vpc-id"
    values = [aws_vpc.eks_vpc.id]
  }

  filter {
    name = "tag:eks"
    values = [ "deployment" ]

  }

  filter {
    name = "tag:tier"
    values = [ "Private"]
  }
}



resource "aws_subnet" "eks_public_subnet" {
  depends_on = [ aws_vpc.eks_vpc, aws_subnet.eks_private_subnet, data.aws_subnets.list_private_subnets_deployment_eks_ids ]

  count = length(data.aws_availability_zones.available_zones.names)
  vpc_id            = aws_vpc.eks_vpc.id
  availability_zone = element(data.aws_availability_zones.available_zones.names, count.index)
  cidr_block = cidrsubnet(var.eks_vpc_cidr, 8, length(data.aws_subnets.list_private_subnets_deployment_eks_ids.ids) + count.index + 1)

  tags = merge(var.default_tags, {
    "Name"                            = "eks-public-subnet-${count.index}-${element(data.aws_availability_zones.available_zones.names, count.index)}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    "tier"                            = "Public"
    "eks"                             = "deployment"
    "kubernetes.io/cluster/${var.cluster_deployment_name}" = "shared"
  })

}



