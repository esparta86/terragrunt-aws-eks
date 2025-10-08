# resource "aws_security_group" "jenkins_agents_ec2" {
#   name        = "${var.environment}-jenkins-agents-ec2"
#   description = "Security Group for ${var.environment} Jenkins EC2 agents"
#   vpc_id      = data.aws_vpc.eks.id

#   egress {
#     description = "Jenkins EC2 agents access to the Internet"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = merge(
#     {
#       Name = "${var.environment}-jenkins-agents-ec2"
#     },
#     local.default_tags
#   )
# }

# resource "aws_security_group_rule" "ssh_ingress_jenkins_agents_ec2" {
#   description       = "Ingress to ${var.environment} Jenkins EC2 agents via SSH from the EKS VPC"
#   security_group_id = aws_security_group.jenkins_agents_ec2.id
#   type              = "ingress"
#   from_port         = 22
#   protocol          = "tcp"
#   to_port           = 22
#   cidr_blocks       = [data.aws_vpc.eks.cidr_block]
# }
