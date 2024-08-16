resource "aws_instance" "app_server" {
  count = length(var.subnet_public_list)
  ami           = "ami-0f8b8f874036055b1"

  instance_type = var.instance_type

  subnet_id = element(var.subnet_public_list,count.index)
  vpc_security_group_ids = [aws_security_group.security_group.id]

  user_data              = file("${path.module}/user-data/setup-nginx.sh")

   key_name = "ubuntu"
  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}


#Elastic IP addresses and associate with the web server created
resource "aws_eip" "public_ip_servers" {
  # depends_on = [ aws_instance.app_server ]
  count = length(var.subnet_public_list)
  vpc = true
  # instance = element(aws_instance.app_server.*.id,count.index)
  instance = aws_instance.app_server[0].id

  tags = {
    "Name" = "public-ip-nginx-server-${count.index}"
  }


}


# Creating security group for NGINX server

resource "aws_security_group" "security_group" {


  name = "security_group_nginx"
  vpc_id = var.vpc_id

 ingress {
   description = "http"
   from_port = 80
   to_port = 80
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
   description = "https"
   from_port = 443
   to_port = 443
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
   description = "http custom"
   from_port = 9000
   to_port = 9000
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
   description = "ssh"
   from_port = 22
   to_port = 22
   cidr_blocks = ["0.0.0.0/0"]
   protocol = "tcp"
 }

 egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

#  tags = var.default_tags

}


