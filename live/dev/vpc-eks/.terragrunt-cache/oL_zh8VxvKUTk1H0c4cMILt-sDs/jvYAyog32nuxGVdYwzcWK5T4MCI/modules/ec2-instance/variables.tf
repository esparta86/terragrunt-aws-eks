variable "instance_type" {
  description = "The instance type to use"
  type        = string
}
variable "instance_name" {
  description = "The name to use for the instance"
  type        = string
}


variable "subnet_public_list" {
  type = list(any)
  description = "list of ID subnets created by vpc module"
}


variable "security_group_nginx_id" {
  type = string
  description = "security group id,created in vpc module"
}

variable "instance_name_mysql" {
  type = string
  description = "Instance name of mysql server"
}


variable "security_group_mysql_id" {
  type = string
  description = "security group id"
}

variable "subnet_private_id" {
  type = string
  description = "subnet id private "
}