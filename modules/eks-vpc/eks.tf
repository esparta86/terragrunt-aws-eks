

# #Provisioning the EKS cluster deployment
resource "aws_eks_cluster" "eks-deployment" {

  depends_on = [ aws_vpc.eks_vpc, aws_subnet.eks_private_subnet,
           aws_subnet.eks_public_subnet, aws_iam_role_policy_attachment.eks-amazonEKSClusterPolicy
 ]

 name = var.cluster_deployment_name
 version = var.version_eks_deployment

 role_arn = aws_iam_role.eks-role.arn

 vpc_config {
   subnet_ids = flatten( [ aws_subnet.eks_public_subnet[*].id, aws_subnet.eks_private_subnet[*].id ])
 }

 timeouts {
   create = "40m"
   delete = "1h"
 }

}