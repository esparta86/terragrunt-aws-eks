

resource "time_sleep" "this" {
  # Duration to wait after the EKS cluster has become active before creating the dataplane components 
  # (EKS managed nodegroup(s), self-managed nodegroup(s), Fargate profile(s))
  create_duration = "30s"
  
  triggers = {
    cluster_name = aws_eks_cluster.this.name
    cluster_endpoint = aws_eks_cluster.this.endpoint
    cluster_version = aws_eks_cluster.this.version
    cluster_certificate_authority_data = aws_eks_cluster.this.certificate_authority[0].data
  }
  
}


module "custom_eks_managed_node_group" {
  source = "./eks-managed-node-group"
  for_each = { for k,v in var.eks_managed_node_groups : k => v }
  
  create_node_group = try(each.value.create, true)
  cluster_name = time_sleep.this.triggers["cluster_name"]
  cluster_endpoint = time_sleep.this.triggers["cluster_endpoint"]
  cluster_version  = time_sleep.this.triggers["cluster_version"]


  #EKS  Managed Node Group specific variables 

  name            = try(each.value.name, each.key)
  subnet_ids      = module.vpc.private_subnets.ids 

  min_size       = try(each.value.min_size, 1) 
  max_size       = try(each.value.max_size, 3)

  desired_size   = try(each.value.desired_size, 2)
  ami_id        = try(each.value.ami_id, null) 
  ami_type     = try(each.value.ami_type, null)
  ami_release_version = try(each.value.ami_release_version, null) 

  capacity_type = try(each.value.capacity_type, "ON_DEMAND") 
  disk_size = try(each.value.disk_size, null)
  instance_types = try(each.value.instance_types, null) 
  labels = try(each.value.labels, null)


  taints = try(each.value.taints, {})
  timeouts = try(each.value.timeouts, {})



 key_name = try(each.value.key_name, null)

 iam_role_arn_nodes = try(each.value.iam_role_arn_nodes, null)


 vpc_security_group_ids = aws_security_group.node[*].id 
 


  # cluster_certificate_authority_data  = time_sleep.this.triggers["cluster_certificate_authority_data"]


 
  

}
