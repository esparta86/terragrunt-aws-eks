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

   node_group_name = "private-nodes-eks-deployment"
   node_role_arn = aws_iam_role.nodes.arn

   subnet_ids = aws_subnet.eks_private_subnet[*].id

   capacity_type = "ON_DEMAND"

   instance_types = [ var.instance_types_workers_eks ]

   scaling_config {
      desired_size = 2
      max_size = 3
      min_size = 2
   }

   update_config {
     max_unavailable = 1
   }

  labels = {
    "role" = "deployment"
  }
}