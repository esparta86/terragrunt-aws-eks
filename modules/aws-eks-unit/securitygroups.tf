

## security groups for EKS cluster ##

locals {
  eks_cluster_sg_name = "${var.name}-eks-cluster-sg"

  cluster_security_group_rules = { for k, v in {
    ingress_nodes_443 = {
      description                = "Allow ingress from nodes to control plane on port 443"
      from_port                  = 443
      to_port                    = 443
      protocol                   = "tcp"
      type                       = "ingress"
      source_node_security_group = true
    }

    } : k => v if var.create_eks_cluster_sg
  }
}



# output "security_rules" {
#   value = local.cluster_security_group_rules

# }


resource "aws_security_group" "cluster" {
  count = var.create_eks_cluster_sg ? 1 : 0

  name        = local.eks_cluster_sg_name
  description = "Security group for EKS cluster ${var.name}"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.default_tags, {
    Name = local.eks_cluster_sg_name
  })


  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_security_group_rule" "cluster" {

  for_each = {
    for k, v in merge(
      local.cluster_security_group_rules,
      var.cluster_security_group_additional_rules
    ) : k => v if var.create_eks_cluster_sg
  }

  from_port         = each.value.from_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.cluster[0].id
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description      = lookup(each.value, "description", null)
  cidr_blocks      = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids  = lookup(each.value, "prefix_list_ids", null)
  self             = lookup(each.value, "self", null)

  source_security_group_id = try(each.value.source_node_security_group, false) ? aws_security_group.node.id : lookup(each.value, "source_security_group_id", null)

  # cidr_blocks = [ aws_vpc.this.cidr_block]    

 
}


### security group for nodes ###

##Always create a security group for nodes, even if not used

locals {

  node_security_group_rules = {

    ingress_cluster_443 = {
      description                   = "Allow API to nodes groups on port 443"
      from_port                     = 443
      to_port                       = 443
      protocol                      = "tcp"
      type                          = "ingress"
      source_cluster_security_group = true
    }

    ingress_cluster_kubelet = {
      description                   = "Allow kubelet to nodes groups on port 10250"
      from_port                     = 10250
      to_port                       = 10250
      protocol                      = "tcp"
      type                          = "ingress"
      source_cluster_security_group = true
    }

    ingress_self_coredns_tcp = {
      description = "Allow coredns to nodes groups on port 53"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      type        = "ingress"
      self        = true
    }

    ingress_self_coredns_udp = {
      description = "Allow coredns to nodes groups on port 53"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      type        = "ingress"
      self        = true
    }

  }

  node_security_groups_reccommended_rules = { for k, v in {
    ingress_nodes_ephemeral = {
      description = "Allow ephemeral ports from nodes to control plane"
      from_port   = 1025
      to_port     = 65535
      protocol    = "tcp"
      type        = "ingress"
      self        = true
    }

    #metric server

    ingress_cluster_4443_webhook = {
      description                   = "Allow API to nodes groups on port 4443"
      from_port                     = 4443
      to_port                       = 4443
      protocol                      = "tcp"
      type                          = "ingress"
      source_cluster_security_group = true
    }

    #prometheus adapter

    ingress_cluster_6443_webhook = {
      description                   = "Allow API to nodes groups on port 6443"
      from_port                     = 6443
      to_port                       = 6443
      protocol                      = "tcp"
      type                          = "ingress"
      source_cluster_security_group = true
    }

    egress_all = {
      description = "Allow all egress traffic from nodes"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    } : k => v if var.node_security_group_enable_recommended_rules

  }
}


resource "aws_security_group" "node" {

  name        = "${var.name}-eks-node-sg"
  description = "Security group for EKS node group ${var.name}"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.default_tags, {
    "Name"                              = "${var.name}-eks-node-sg"
    "kubernetes.io/cluster/${var.name}" = "owned"
  })
  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_security_group_rule" "node" {

   for_each = { for k,v in merge(
    local.node_security_group_rules,
    local.node_security_groups_reccommended_rules,
    # var.node_security_group_additional_rules
   ) : k => v  }

   security_group_id = aws_security_group.node.id
   protocol = each.value.protocol
   from_port = each.value.from_port
   to_port = each.value.to_port
   type = each.value.type


   description = lookup(each.value, "description", null)
   cidr_blocks = lookup(each.value, "cidr_blocks", null)
   ipv6_cidr_blocks = lookup(each.value, "ipv6_cidr_blocks", null)
   prefix_list_ids = lookup(each.value, "prefix_list_ids", null)
   self = lookup(each.value, "self", null)
   source_security_group_id = try(each.value.source_cluster_security_group, false) ? aws_security_group.cluster[0].id : lookup(each.value, "source_security_group_id", null)

  
}



