

resource "aws_iam_role" "ec2_s3_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      },
    ]
  })
  tags = merge(local.common_tags2, {
    Name = "${var.naming_prefix}-ec2-iam-role"
  })
}


resource "aws_iam_policy" "ec2_s3_policy" {
  name = "ec2-iam-s3-policy"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "s3:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
      ]
    }
  )
  tags = merge(local.common_tags2, {
    Name = "${var.naming_prefix}-ec2-s3-policy"
  })

}

resource "aws_iam_policy_attachment" "ec2_s3_role_policy" {
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
  roles      = [aws_iam_role.ec2_s3_role.name]
  name       = "${var.naming_prefix}-ec2-s3-policy-att"
}

resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  role = aws_iam_role.ec2_s3_role.name
  tags = merge(local.common_tags2, {
    Name = "${var.naming_prefix}-ec2-s3-instance-profile"
  })
}



locals {
  common_tags2 = {
    company     = var.company
    project     = "${var.company}-${var.project}"
    environment = var.environment
  }

  naming_prefix = "${var.naming_prefix}-${var.environment}"
}


module "vpc_a_bastion_host" {
  source           = "./web"
  instance_type    = var.instance_type
  instance_key     = var.instance_key
  subnet_id        = aws_subnet.public_subnet[0].id
  vpc_id           =  aws_vpc.main_vpc.id
  ec2_name         = "Bastion Host A"
  sg_ingress_ports = var.sg_ingress_public
  common_tags      = local.common_tags2
  naming_prefix    = local.naming_prefix
  instance_profile = aws_iam_instance_profile.ec2_s3_instance_profile.name
}


module "vpc_a_private_host" {
  source           = "./web"
  instance_type    = var.instance_type
  instance_key     = var.instance_key
  subnet_id        = aws_subnet.private_subnet[0].id
  vpc_id           = aws_vpc.main_vpc.id
  ec2_name         = "Private Host A"
  sg_ingress_ports = var.sg_ingress_private
  common_tags      = local.common_tags2
  naming_prefix    = local.naming_prefix
  instance_profile = aws_iam_instance_profile.ec2_s3_instance_profile.name
}


resource "aws_security_group_rule" "public_in_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.vpc_a_private_host.security_group_id
  source_security_group_id = module.vpc_a_bastion_host.security_group_id
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-test-bucket-colocho86"

  tags = merge(local.common_tags2, {
    Name = "${local.naming_prefix}-s3-bucket"
  })
}
