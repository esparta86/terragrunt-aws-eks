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



//////

resource "aws_iam_role" "iam-role-fluent-bit" {
  name                  = "role-fluent-bit-test"
  force_detach_policies = true
  max_session_duration  = 3600
  path                  = "/"
  assume_role_policy    = jsonencode({


    Version= "2012-10-17"
    Statement: [
      {
        Effect: "Allow"
        Principal: {
            Federated: "arn:aws:iam::734237051973:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer}"
        }
        Action: "sts:AssumeRoleWithWebIdentity"
        Condition: {
          StringEquals: {
            "oidc.eks.${var.region}.amazonaws.com/id/${aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer}:aud": "sts.amazonaws.com",
            "oidc.eks.${var.region}.amazonaws.com/id/${aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer}:sub": "system:serviceaccount:${var.cloudwatch_namespace}:${var.eks-service_account-name}"
          }
        }
      }
    ]


})

}

resource "aws_iam_policy" "policy_sa_logs" {
  name        = "policy-sa-fluent-bit-logs"
  path        = "/"
  description = "policy for EKS Service Account fluent-bit "
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutRetentionPolicy",
                "cloudwatch:PutLogsEvents"
            ],
            "Resource": "arn:aws:logs:${var.region}:734237051973:*:*"
        }
    ]
}
EOF
}

######## Policy attachment to IAM role ########

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.iam-role-fluent-bit.name
  policy_arn = aws_iam_policy.policy_sa_logs.arn
}


