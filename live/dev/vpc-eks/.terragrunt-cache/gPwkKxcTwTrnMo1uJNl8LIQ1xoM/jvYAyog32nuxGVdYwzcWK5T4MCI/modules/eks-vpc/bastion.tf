# resource "aws_instance" "bastion-instance" {
#     ami = "ami-0e472ba40eb589f49"
#     instance_type = "t2.micro"
#     subnet_id = aws_subnet.eks_public_subnet[0].id
#     vpc_security_group_ids = [ aws_security_group.allow-ssh.id ]

#     key_name = "ubuntu"
#     tags = {
#       "Name" = "public-instance"
#     }
# }

# resource "aws_eip" "publicIPBastion" {
#   vpc   = true

#   instance = aws_instance.bastion-instance.id
#   tags = merge(var.default_tags, {
#     "Name" = "public-ip-bastion-host"
#   })

# }
