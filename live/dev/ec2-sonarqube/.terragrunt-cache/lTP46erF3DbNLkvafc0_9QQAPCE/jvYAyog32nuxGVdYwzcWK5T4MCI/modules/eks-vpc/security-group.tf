locals {
  node_sg_name = coalesce(var.node_security_group_name,"${var.cluster_deployment_name}-node")
  create_node_sg = var.create_node_security_group


  node_security_group_rules = {
    ingress_cluster_443 = {
      description                   = "Cluster API to node groups"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      type                          = "ingress"
      source_cluster_security_group = true
    }

    ingress_cluster_kubelet = {
      description                   = "Cluster API to node kubelets"
      protocol                      = "tcp"
      from_port                     = 10250
      to_port                       = 10250
      type                          = "ingress"
      source_cluster_security_group = true
    }

    ingress_self_coredns_tcp = {
      description = "Node to node CoreDNS"
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      self        = true
    }

    ingress_self_coredns_udp = {
      description = "Node to node CoreDNS UDP"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      self        = true
    }

  }



}

resource "aws_security_group" "allow-ssh" {
    vpc_id = aws_vpc.eks_vpc.id
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


# resource "aws_security_group" "node" {

#   count = local.create_node_sg ? 1 : 0
# #   name        =  local.node_sg_name
#   name_prefix =  "${local.node_sg_name}-"

#   vpc_id = aws_vpc.eks_vpc.id
#   tags = merge(
#      var.default_tags,
#     {
#      "Name"                                      = local.node_sg_name
#      "kubernetes.io/cluster/${var.cluster_deployment_name}" = "owned"
#     })

#     lifecycle {
#       create_before_destroy = true
#     }
# }


# resource "aws_security_group_rule" "node" {
#   for_each = {
#     for k,v in merge(
#         local.node_security_group_rules,
#         var.node_security_group_additional_rules
#     ): k => v if local.create_node_sg
#    }

#    # Required
#   security_group_id = aws_security_group.node[0].id
#   protocol          = each.value.protocol
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
#   type              = each.value.type

#   # Optional
#   description              = lookup(each.value, "description", null)
#   cidr_blocks              = lookup(each.value, "cidr_blocks", null)
#   self                     = lookup(each.value, "self", null)

#   source_security_group_id = lookup(each.value, "source_security_group_id", null)

# }



# resource "aws_security_group" "node-group" {
#     name_prefix = "node-group-sg-"
#     vpc_id = aws_eks_cluster.eks-deployment.vpc_config.0.vpc_id

#     ingress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         self = true
#     }

#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = [ "0.0.0.0/0" ]
#     }

#     tags = {
#       "kubernetes.io/cluster/eks_colocho86" = "owned"
#       "aws:eks:cluster-name" = "eks_colocho86"
#       "Prefix" = "node-group-sg-"
#     }
# }