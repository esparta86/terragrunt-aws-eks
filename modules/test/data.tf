

data "aws_ec2_instance_type_offerings" "example" {
    filter {
      name = "instance-type"
      values = [ "t2.micro","t3.micro" ]
    }

    filter {
      name = "location"
      values = [ "use1-az4" ]
    }

    location_type = "availability-zone-id"
}

# data "aws_vpc" "vpc" {
#     # id = "vpc-05789e21e752f5cb0"
#     filter {
#       name = "tag:Name"
#       values = [ "main" ]
#     }
# }

# data "aws_subnets" "subnetmain_public" {
#     filter {
#       name = "vpc-id"
#       values = [ data.aws_vpc.vpc.id ]
#     }

#     filter {
#       name = "tag:scope"
#       values = [ "public" ]
#     }
# }

# data "aws_subnets" "subnetmain_private" {
#     filter {
#       name = "vpc-id"
#       values = [ data.aws_vpc.vpc.id ]
#     }

#     filter {
#       name = "tag:Name"
#       values = [ "private_subnet" ]
#     }
# }

# data "aws_subnet" "public-subnets" {
#     for_each = toset(data.aws_subnets.subnetmain_public.ids)
#     id = each.value

# }

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version ="1.27"
  most_recent        = true
}

data "aws_ami" "eks_default" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.27-v*"]
  }

  most_recent = true
  owners      = ["amazon"]
}