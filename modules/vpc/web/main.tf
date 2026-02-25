####################################################
# Get latest Amazon Linux 2 AMI
####################################################
# data "aws_ami" "amazon-linux-2" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }


data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # This pattern targets the standard AL2023 x86_64 HVM image
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

####################################################
# Create the security group for EC2
####################################################
resource "aws_security_group" "security_group" {
  description = "Allow traffic for EC2"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_ports
    iterator = sg_ingress

    content {
      description = sg_ingress.value["description"]
      from_port   = sg_ingress.value["port"]
      to_port     = sg_ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.naming_prefix}-sg-ec2-${var.ec2_name}"
  })
}


####################################################
# Create the Linux EC2 instance with a website
####################################################
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.security_group.id]

  iam_instance_profile = var.instance_profile

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  EOF
  tags = merge(var.common_tags, {
    Name = "${var.naming_prefix}-ec2-${var.ec2_name}"
  })
}
