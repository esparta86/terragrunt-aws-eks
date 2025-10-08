# data "aws_eks_cluster" "eks_cluster" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "eks_cluster" {
#   name = var.cluster_name
# }

# data "aws_kms_key" "secrets_manager" {
#   key_id = "alias/aws/secretsmanager"
# }

# data "aws_vpc" "eks" {
#   filter {
#     name   = "tag:Name"
#     values = [var.cluster_name]
#   }
# }

# data "aws_subnets" "eks" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.eks.id]
#   }

#   tags = {
#     Name = "*private-${var.region}*"
#   }
# }

# output "subnet_ids" {
#   value = data.aws_subnets.eks.ids
  
# }

# data "vault_generic_secret" "github_auth" {
#   path = "ste/${var.environment}/github-auth"
# }

# data "vault_generic_secret" "nexus_auth" {
#   path = "ste/${var.environment}/nexus"
# }

# data "vault_generic_secret" "jenkins_auth" {
#   path = "ste/${var.environment}/jenkins"
# }

# data "vault_generic_secret" "ste_secret" {
#   path = "ste/${var.environment}/ste-secret"
# }


data "aws_availability_zones" "available" { 
  # filter {
  #   name   = "zone-name"
  #   values = var.azs
  # }

  filter {
    name   = "zone-name"
    values = ["us-east-1e", "us-east-1f"]
  }
}


output "zones" {  
  value = data.aws_availability_zones.available.names
}

output "list" {
  value = local.list_azs
}

output "private_subnets" {
  value = local.private_subnets
}

output "public_subnets" {
  value = local.public_subnets
}

locals {
  list_azs = slice(data.aws_availability_zones.available.names, 0, length(["us-east-1e", "us-east-1f"]))

   private_subnets = [ for i,v in local.list_azs : cidrsubnet("10.0.0.0/16", 4, i) ]
   public_subnets = [ for i,v in local.list_azs : cidrsubnet("10.0.0.0/16", 8, i + 48) ]
}
