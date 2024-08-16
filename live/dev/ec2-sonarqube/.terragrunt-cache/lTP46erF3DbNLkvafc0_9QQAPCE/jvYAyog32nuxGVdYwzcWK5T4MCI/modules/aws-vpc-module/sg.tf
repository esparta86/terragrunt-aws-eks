resource "aws_security_group" "additional" {
  name_prefix = "${local.name}-additional"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  tags = merge(var.default_tags, { Name = "${local.name}-additional" })


}


resource "aws_security_group" "allow-ssh" {
    vpc_id = module.vpc.vpc_id
    name = "allow-ssh"
    description = "security group that allows ssh and all egress traffic"

    egress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 0
      protocol = "-1"
      to_port = 0
    }

    ingress  {
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 22
      protocol = "tcp"
      to_port = 22
    }

    tags = {
      "Name" = "allow-ssh"
    }

}