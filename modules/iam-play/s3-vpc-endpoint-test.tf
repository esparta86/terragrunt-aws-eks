
//Building server in private subnet
resource "aws_instance" "private_server" {
  ami = "ami-0f890494e52693975"
  instance_type = var.instance_type

  vpc_security_group_ids = [ aws_security_group.server-sg-bastion.id ]
  user_data = file("${path.module}/user-data/setup-mysql.sh")

  subnet_id = var.subnet_private_id
  tags ={
    Name = var.instance_name_server
  }

  key_name = "ubuntu"
}

//BUILDING PUBLIC SERVER TO JUMP TO PRIVATE SERVER
resource "aws_instance" "app_server_public" {
  count = length(var.subnet_public_list)
  ami           = "ami-0f890494e52693975"

  instance_type = var.instance_type

  subnet_id = element(var.subnet_public_list,count.index)
  vpc_security_group_ids = [ aws_security_group.ssh-sg-group-vm-public.id]

#   user_data              = file("${path.module}/user-data/setup-nginx.sh")

   key_name = "ubuntu"
  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}


#Elastic IP addresses and associate with the web server created
resource "aws_eip" "public_ip_servers" {
  depends_on = [ aws_instance.app_server_public ]
  count = length(var.subnet_public_list)
  vpc = true
  instance = element(aws_instance.app_server_public.*.id,count.index)


  tags = {
    "Name" = "public-ip-server-${count.index}"
  }


}



# --------------------- security group to access to public server and  ---------------------#
# --------------------- after that jump to private server --------------------- #

resource "aws_security_group" "ssh-sg-group-vm-public" {
    name = "ssh-sg-group-vm-public"
    vpc_id = var.vpc_id

    tags = merge(var.default_tags,{
      "Name" = "ssh-sg-group-vm-public"
    })

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group_rule" "ssh-rule-vms" {
    for_each = { for k,v in
    var.cluster_security_group_rules_vms : k => v }

    from_port = each.value.from_port
    protocol = each.value.protocol
    security_group_id = aws_security_group.ssh-sg-group-vm-public.id
    to_port = each.value.to_port
    type = each.value.type
    cidr_blocks = each.value.cidr_blocks
}


resource "aws_security_group" "server-sg-bastion" {
  name = "ssh-web-server-group"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags,{
    "Name" = "sg-bastion-ssh"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh-rule-bastion-server-vms" {
    for_each = { for k,v in
    var.cluster_security_group_rules_bastion_server_vms : k => v }

    from_port = each.value.from_port
    protocol = each.value.protocol
    security_group_id = aws_security_group.server-sg-bastion.id
    to_port = each.value.to_port
    type = each.value.type
    source_security_group_id = aws_security_group.ssh-sg-group-vm-public.id
}

resource "aws_security_group_rule" "egress_all_traffic" {
    from_port = 0
    protocol = -1
    security_group_id = aws_security_group.server-sg-bastion.id
    to_port = 0
    type = "egress"
    cidr_blocks = [ "0.0.0.0/0" ]
}



//
