resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}


data "aws_availability_zones" "available" {
  filter {
    name   = "zone-name"
    values = ["us-east-1a", "us-east-1b", "us-east-1c","us-east-1d"]
  }
}


# resource "aws_subnet" "subnet" {
#   vpc_id = aws_vpc.vpc.id
#   cidr_block = cidrsubnet(var.vpc_cidr,8,1)
#   availability_zone = "us-east-1a"

#   tags = merge(var.tags, {
#     "Name" = "private-subnet-1}"
#     "tier" = "Private"
#   })

#   depends_on = [ aws_vpc.vpc ]
# }


resource "aws_subnet" "private_subnets" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 1)

  tags = merge(var.tags, {
    "Name"                            = "private-subnet-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "tier"                            = "Private"
    "purpose"                         = "Redis"
  })

}


data "aws_subnets" "list_private_subnets_redis" {
  depends_on = [
    aws_vpc.vpc, aws_subnet.private_subnets
  ]

  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:purpose"
    values = ["Redis"]
  }

  filter {
    name   = "tag:tier"
    values = ["Private"]
  }

  filter {
    name = "availability-zone"
    values = var.redis_availability_zones
  }

  # tags = {
  #   "eks" = "deployment"
  # }
}


# data "aws_subnets" "list_private_subnets_redis_second" {
#   depends_on = [
#     aws_vpc.vpc, aws_subnet.private_subnets
#   ]

#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.vpc.id]
#   }

#   filter {
#     name   = "tag:purpose"
#     values = ["Redis"]
#   }

#   filter {
#     name   = "tag:tier"
#     values = ["Private"]
#   }

#   filter {
#     name = "availability-zone"
#     values = var.redis_availability_zones_second
#   }

#   # tags = {
#   #   "eks" = "deployment"
#   # }
# }