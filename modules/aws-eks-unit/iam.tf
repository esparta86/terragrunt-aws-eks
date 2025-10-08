


resource "aws_iam_role" "cluster-role" {
  name = "${var.name}-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
  tags = merge(var.default_tags, {
    Name = "${var.name}-cluster"
  })

}

resource "aws_iam_role_policy_attachment" "cluster-policy" {
  role       = aws_iam_role.cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  depends_on = [aws_iam_role.cluster-role]
}


resource "aws_iam_role" "node-role" {
  name = "${var.name}-node"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = merge(var.default_tags, {
    Name = "${var.name}-node"
  })
}


resource "aws_iam_role_policy_attachment" "node-policy" {
  for_each = { for p in [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ] : p => p }

  policy_arn = each.value
  role       = aws_iam_role.node-role.name
  depends_on = [aws_iam_role.node-role]
}



