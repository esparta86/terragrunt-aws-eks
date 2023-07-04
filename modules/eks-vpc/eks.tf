

# #Provisioning the EKS cluster deployment
resource "aws_eks_cluster" "eks-deployment" {

  depends_on = [ aws_vpc.eks_vpc, aws_subnet.eks_private_subnet,
           aws_subnet.eks_public_subnet, aws_iam_role_policy_attachment.eks-amazonEKSClusterPolicy,
           aws_cloudwatch_log_group.cloudwatcheks
 ]

 name = var.cluster_deployment_name
 version = var.version_eks_deployment

 role_arn = aws_iam_role.eks-role.arn

 vpc_config {
   subnet_ids = flatten( [ aws_subnet.eks_public_subnet[*].id, aws_subnet.eks_private_subnet[*].id ])

   endpoint_private_access = "true"
   endpoint_public_access  = "true"

 }

 timeouts {
   create = "40m"
   delete = "1h"
 }

 enabled_cluster_log_types = [ "api","audit" ]

 kubernetes_network_config {
   service_ipv4_cidr = "10.100.0.0/16"
 }

}


resource "aws_cloudwatch_log_group" "cloudwatcheks" {
  name = "/aws/eks/${var.cluster_deployment_name}/cluster"
  retention_in_days = 7

}