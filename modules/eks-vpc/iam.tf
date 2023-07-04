# Role required to create a cluster with trust policy
#
resource "aws_iam_role" "eks-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


#  This policy let kubernetes to manage resources on your behalf
# some tasks permited
# autoscaling read and update the configuration
# ec2 work with volumens and network resources that are associated to amazon EC2 nodes
# elasticloadbalancing let k8s works with ELB and add nodes to them as targets.
# iam let k8s control plane can dynamically provision ELB requested by K8S services
resource "aws_iam_role_policy_attachment" "eks-amazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name

  depends_on = [ aws_iam_role.eks-role ]
}




resource "aws_iam_role" "nodes" {
    name = "eks-node-group-nodes"

    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}




# this policy let EKS Worker to connect to EKS Master : ---> AmazonEKSWorkerNodePolicy
# this policy provides a plugin called amzon-vpc-cni-k8s
# this plugin help us to provide a private IPV4 or IPV6 address from our VPC to each POD --> AmazonEKS_CNI_Policy
## Provide read-only access to Amazon EC2 Container Registry repositories --> AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "nodes-policies" {

  for_each = { for p in [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"  #To attach the necessary policy to the IAM role for your worker nodes
    # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html
  ] : p => p }

  policy_arn = each.key
  role = aws_iam_role.nodes.name
}




