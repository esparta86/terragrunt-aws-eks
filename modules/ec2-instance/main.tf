resource "aws_instance" "app_server_nginx" {
  count = length(var.subnet_public_list)
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = var.instance_type

  subnet_id = element(var.subnet_public_list,count.index)

  tags = {
    Name = var.instance_name
  }
}


