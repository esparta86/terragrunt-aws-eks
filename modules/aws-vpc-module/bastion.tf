# resource "aws_instance" "bastion-instance" {
#     ami = "ami-0e472ba40eb589f49"
#     instance_type = "t2.micro"
#     subnet_id = module.vpc.public[0]
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


resource "aws_rds_cluster_parameter_group" "aurora_clusterparameter_group" {
 name        = "rds-cluster-pg"
  family      = "aurora5.6"
  description = "RDS default cluster parameter group"

  dynamic "parameter" {
    for_each = var.create_db_cluster_parameter_group ? var.db_cluster_parameter_group_parameters : []
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }
}