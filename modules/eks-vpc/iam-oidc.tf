# --------------------------------------------- EKS deployment

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer

  depends_on = [ aws_eks_cluster.eks-deployment,
  aws_eks_node_group.private-nodes ]
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]

  url = aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer

  depends_on = [ data.tls_certificate.eks ]
}



