resource "aws_instance" "app_server_nginx" {
  count = length(var.subnet_public_list)
  ami           = "ami-0631713b28ac842f0"

  instance_type = var.instance_type

  subnet_id = element(var.subnet_public_list,count.index)
  vpc_security_group_ids = [var.security_group_nginx_id]

  user_data              = file("${path.module}/user-data/setup-nginx.sh")

   key_name = "ubuntu"
  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}


#Elastic IP addresses and associate with the web server created
resource "aws_eip" "public_ip_servers" {
  depends_on = [ aws_instance.app_server_nginx ]
  count = length(var.subnet_public_list)
  vpc = true
  instance = element(aws_instance.app_server_nginx.*.id,count.index)


  tags = {
    "Name" = "public-ip-nginx-server-${count.index}"
  }


}


resource "aws_instance" "mysql_server" {
  ami = "ami-0631713b28ac842f0"
  instance_type = var.instance_type

  vpc_security_group_ids = [ var.security_group_mysql_id ]
  user_data = file("${path.module}/user-data/setup-mysql.sh")

  subnet_id = var.subnet_private_id
  tags ={
    Name = var.instance_name_mysql
  }

  key_name = "ubuntu"
}

