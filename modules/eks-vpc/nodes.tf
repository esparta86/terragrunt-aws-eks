# Provisioning EKS NODE GROUP
# Important all subnets associated to EKS already exists and the EKS cluster already was created
resource "aws_eks_node_group" "private-nodes" {

  depends_on = [
    aws_vpc.eks_vpc,
    aws_subnet.eks_private_subnet,
    aws_subnet.eks_public_subnet,
    aws_eks_cluster.eks-deployment
   ]

   cluster_name = aws_eks_cluster.eks-deployment.name

   node_group_name = "private-nodes-eks-colocho86"
   node_role_arn = aws_iam_role.nodes.arn

   subnet_ids = aws_subnet.eks_private_subnet[*].id

   capacity_type = "ON_DEMAND"

  #  instance_types = [ var.instance_types_workers_eks ]

   launch_template {
     id = aws_launch_template.default.id
     version = "$Latest"
   }

   scaling_config {
      desired_size =2
      max_size = 2
      min_size = 2
   }

   update_config {
     max_unavailable = 1
   }

  labels = {
    "role" = "deployment"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
     ]

  }
}

resource "aws_launch_template" "default" {
  name_prefix = "eks-launch-template-2"
  instance_type =  var.instance_types_workers_eks
  key_name = "ubuntu"
  # vpc_security_group_ids = [ aws_security_group.allow-ssh.id ]
  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
/etc/eks/bootstrap.sh eks_colocho86 --kubelet-extra-args='--cluster-dns=169.254.20.10 --node-labels=kubelet=mykubelet2023'
echo "APPLYING CHANGES ................................................ KUBECTL"
--==MYBOUNDARY==--\

    EOF
    )
lifecycle {
    create_before_destroy = true
  }

}