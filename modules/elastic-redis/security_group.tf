locals {
  cidr_blocks = var.whitelist_cidr_blocks
}




resource "aws_security_group" "this" {
  name        = "${var.environment}-${var.redis_name}"
  description = "Allow AWS ElastiCache Redis inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags        = var.tags

  ingress {
    description = "Allow AWS ElastiCache Redis connections"
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description     = "Allow AWS ElastiCache Redis connections"
    from_port       = var.redis_port
    to_port         = var.redis_port
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



# resource "aws_security_group" "this2" {
#   name        = "${var.environment}-${var.redis_name}-2"
#   description = "Allow AWS ElastiCache Redis inbound traffic"
#   vpc_id      = aws_vpc.vpc.id
#   tags        = var.tags

#   ingress {
#     description = "Allow AWS ElastiCache Redis connections"
#     from_port   = var.redis_port
#     to_port     = var.redis_port
#     protocol    = "tcp"
#     cidr_blocks = local.cidr_blocks
#   }

#   ingress {
#     description     = "Allow AWS ElastiCache Redis connections"
#     from_port       = var.redis_port
#     to_port         = var.redis_port
#     protocol        = "tcp"
#     security_groups = var.security_group_ids
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }
