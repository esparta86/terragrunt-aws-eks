##  The following resources are created to work with ec2-instance module ##
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = merge(var.default_tags, {
    Name = "main"
  })
}


resource "aws_vpc" "main_vpc2" {
  count = var.required_second_vpc ? 1 : 0
  cidr_block = var.vpc_cidr2
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = merge(var.default_tags, {
    Name = "main-vpc2"
  })
}

######################  NGNIX SERVER #########################
##  We are going to deploy a ngix server using a bash script to initialize the vms
##  these are going to use a subnet public, but we are going to use
##   Elastic IP addresses to expose them over the internet as good practice
##   The internal private ips are not be able to access to internet

#Create Internet Gateway and attach VPC
# check variablees.tf
# @default_tags contains default tags to inject into resources
# @igw_tags contains the name of Intenet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(var.default_tags,var.igw_tags)
}

resource "aws_internet_gateway" "igw2" {
  count = var.required_second_vpc ? 1 : 0
  vpc_id = aws_vpc.main_vpc2[0].id
  tags = merge(var.default_tags,var.igw_tags)
}


#Route table for public subnets
# @default_tags contains default tags to inject into resources
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "Route table for Internet Gateway"
  }
}

resource "aws_route_table" "public_rt2" {
  count = var.required_second_vpc ? 1 : 0
  vpc_id = aws_vpc.main_vpc2[0].id
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw2[0].id
  }

  tags = {
    "Name" = "RouteTableVPC2"
  }
}


# We are going to create one subnet per zone
# @var.azs it is a list that stores all zones for one region
# cidrsubnet is a function that help us to create cidr
# resources to understand how works
#   - https://www.terraform.io/language/functions/cidrsubnet
#   - https://ntwobike.medium.com/how-cidrsubnet-works-in-terraform-f6ccd8e1838f
resource "aws_subnet" "public_subnet" {
  count = length(var.azs)
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = element(var.azs,count.index)
  cidr_block = cidrsubnet(var.vpc_cidr,4,count.index+1)
  map_public_ip_on_launch = false

   tags = {
     "Name" = "subnet-${count.index}-public"
     "scope" = "public"
   }

}

resource "aws_subnet" "public_subnet2" {
  count = var.required_second_vpc ? length(var.azs) : 0
  vpc_id = aws_vpc.main_vpc2[0].id
  availability_zone = element(var.azs,count.index)
  cidr_block = cidrsubnet(var.vpc_cidr2,4,count.index+1)
  map_public_ip_on_launch = false

   tags = {
     "Name" = "subnet-${count.index}-public-vpc2"
     "scope" = "public"
   }

}


resource "aws_route_table_association" "public_rt_association" {
  count = length(var.azs)
  subnet_id = element(aws_subnet.public_subnet.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id

  depends_on = [ aws_route_table.public_rt]
}

resource "aws_route_table_association" "public_rt_association2" {
  count = var.required_second_vpc ? length(var.azs) : 0
  subnet_id = element(aws_subnet.public_subnet2.*.id,count.index)
  route_table_id = aws_route_table.public_rt2[0].id

  depends_on = [ aws_route_table.public_rt2]
}


#Creating security group for NGINX server

# resource "aws_security_group" "security_group" {
#   depends_on = [ aws_vpc.main_vpc ]

#   name = "security_group_nginx"
#   vpc_id = aws_vpc.main_vpc.id

#  ingress {
#    description = "http"
#    from_port = 80
#    to_port = 80
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  ingress {
#    description = "ssh"
#    from_port = 22
#    to_port = 22
#    cidr_blocks = ["0.0.0.0/0"]
#    protocol = "tcp"
#  }

#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  tags = var.default_tags

# }


######################  MYSQL SERVER #########################




#Create a private subnet
# check variablees.tf
# @default_tags contains default tags to inject into resources
# @private_subnet_tags contains the name of private subnet
# @develop_private_subnet_cidr contains the CIDR that subnet is going to use
resource "aws_subnet" "private_subnet" {
  count = var.required_private_subnets ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1a"
  tags = merge({"Name"= "private-subnet-1a"},var.default_tags)
}


resource "aws_subnet" "private_subnet3" {
  count = var.required_second_vpc ? 1 : 0
  vpc_id = aws_vpc.main_vpc2[0].id
  cidr_block = var.private_subnet_cidr3
  availability_zone = "us-east-1b"
  tags = merge({"Name"= "private-subnet-1b-vpc2"},var.default_tags)
}


resource "aws_subnet" "private_subnet4" {
  count = var.required_second_vpc ? 1 : 0
  vpc_id = aws_vpc.main_vpc2[0].id
  cidr_block = var.private_subnet_cidr4
  availability_zone = "us-east-1a"
  tags = merge({"Name"= "private-subnet-1a-vpc2"},var.default_tags)
}


resource "aws_subnet" "private_subnet2" {
  count = var.required_private_subnets ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr2
  availability_zone = "us-east-1b"
  tags = merge({"Name"= "private-subnet-1b"},var.default_tags)
}

resource "aws_eip" "ip_nat2" {
  count = var.required_second_vpc ? 1 : 0
  vpc = true
  tags = merge(var.default_tags,{
    "Name" = "elasticIpNat2"
  })
}

resource "aws_eip" "ip_nat" {
  count = var.required_private_subnets ? 1 : 0
  vpc = true
  tags = merge(var.default_tags,{
    "Name" = "elasticIpNat"
  })
}

#Creating the NAT gateway using the subnet id and allocation id
# Review the sample https://aws.amazon.com/premiumsupport/knowledge-center/nat-gateway-vpc-private-subnet/
# IMPORTANT!
# - To create a NAT gateway is required to have a public subnet that is going to host the NAT gateway
#   The route table for the PUBLIC subnet should contains a route to the Internet through an Internet gateway
# - Provision an unattached Elastic IP address (EIP)
# - You need to update the route table of the private subnet hosting the EC2 instances that need internet access

resource "aws_nat_gateway" "nat_gateway" {
  count = var.required_private_subnets ? 1 : 0
  allocation_id = aws_eip.ip_nat[0].id
  subnet_id = element(aws_subnet.public_subnet.*.id,0)
  tags = merge(var.default_tags,{
    "Name" = "natGateway"
  })

  depends_on = [ aws_eip.ip_nat ]

}

resource "aws_nat_gateway" "nat_gateway2" {
  count = var.required_second_vpc ? 1 : 0
  allocation_id = aws_eip.ip_nat2[0].id
  subnet_id = element(aws_subnet.public_subnet2.*.id,0)
  tags = merge(var.default_tags,{
    "Name" = "natGateway2"
  })

  depends_on = [ aws_eip.ip_nat2 ]

}


locals {

  route_nat1 = var.required_nat_main_vpc ? [ {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }] : []


}
#Route table for private subnets
# @default_tags contains default tags to inject into resources
resource "aws_route_table" "private_rt" {
  count = var.required_private_subnets ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }
  # dynamic "route" {
  #   for_each = local.route_nat1
  #   content {
  #     cidr_block = route.value["cidr_block"]
  #     nat_gateway_id = route.value["nat_gateway_id"]
  #   }

  # }

}


resource "aws_route_table" "private_rt2" {
  count = var.required_second_vpc ? 1 : 0
  vpc_id = aws_vpc.main_vpc2[0].id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway2[0].id
  }
}


#Route table Association with private Subnets
resource "aws_route_table_association" "private_rt_association" {
  count = var.required_private_subnets ? 1 : 0
  subnet_id = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_rt[0].id
}

resource "aws_route_table_association" "private_rt_association2" {
  count = var.required_private_subnets ? 1 : 0
  subnet_id = aws_subnet.private_subnet2[0].id
  route_table_id = aws_route_table.private_rt[0].id
}


resource "aws_route_table_association" "private_rt_association3" {
  count = var.required_second_vpc ? 1 : 0
  subnet_id = aws_subnet.private_subnet3[0].id
  route_table_id = aws_route_table.private_rt2[0].id
}

resource "aws_route_table_association" "private_rt_association4" {
  count = var.required_second_vpc ? 1 : 0
  subnet_id = aws_subnet.private_subnet4[0].id
  route_table_id = aws_route_table.private_rt2[0].id
}

# resource "aws_security_group" "sg_mysql" {
#   depends_on = [ aws_vpc.main_vpc ]
#   count = var.create_sg_mysql == true ? 1 : 0

#   name = "sg for mysql servers"
#   description = "Allow mysql inbound traffic"

#   vpc_id = aws_vpc.main_vpc.id

#   ingress {
#     description = "allow tcp"
#     from_port = 3306
#     to_port = 3306
#     protocol = "tcp"
#     security_groups = [ aws_security_group.security_group.id ]
#   }

#   ingress {
#     description = "allow ssh"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     security_groups = [ aws_security_group.security_group.id]

#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }

# }
