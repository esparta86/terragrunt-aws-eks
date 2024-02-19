

# #Provisioning the EKS cluster deployment
resource "aws_eks_cluster" "eks-deployment" {

  depends_on = [ aws_vpc.eks_vpc, aws_subnet.eks_private_subnet,
           aws_subnet.eks_public_subnet, aws_iam_role_policy_attachment.eks-amazonEKSClusterPolicy,
           aws_cloudwatch_log_group.cloudwatcheks
    ]

    name = var.cluster_deployment_name
    version = var.version_eks_deployment
    role_arn = aws_iam_role.eks-role.arn
    enabled_cluster_log_types = var.cluster_log_types

    vpc_config {
      subnet_ids = flatten( [ aws_subnet.eks_public_subnet[*].id, aws_subnet.eks_private_subnet[*].id ])
      endpoint_private_access = "true"
      endpoint_public_access  = "true"
      public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    }


    timeouts {
      create = lookup(var.eks_timeout,"create",null)
      delete = lookup(var.eks_timeout,"delete",null)
      update = lookup(var.eks_timeout,"update",null)
    }



    kubernetes_network_config {
      service_ipv4_cidr = var.eks_service_ipv4cidr
    }

}


resource "aws_cloudwatch_log_group" "cloudwatcheks" {
  name = "/aws/eks/${var.cluster_deployment_name}/cluster"
  retention_in_days = 7
}
