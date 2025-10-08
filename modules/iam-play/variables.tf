# variable "aws_account_id" {
#   description = "AWS account ID"
#   type        = string
# }

# variable "cluster_name" {
#   description = "EKS cluster name"
#   type        = string
# }

# variable "jenkins_namespace" {
#   description = "Kubernetes namespace name for Jenkins"
#   type        = string
# }

# variable "jenkins_controller_service_account" {
#   description = "Kubernetes service account name for Jenkins Controller"
#   type        = string
# }

# variable "environment" {
#   description = "The environment name, overridden by CI/CD"
#   type        = string
#   default     = "dev"
# }

# variable "region" {
#   description = "AWS Region to deploy"
#   type        = string
#   default     = "us-east-1"
# }

# variable "service" {
#   description = "Service name"
#   type        = string
# }

# variable "stack" {
#   description = "The Stack name, overridden by CI/CD"
#   type        = string
#   default     = "jenkins"
# }

# variable "project_name" {
#   description = "Project name"
#   type        = string
# }

# variable "tags" {
#   description = "Tags"
#   type        = map(any)
#   default     = {}
# }

# variable "mount_point" {
#   description = "EKS cluster name"
#   type        = string
# }

# variable "jenkins_controller_pvc_storage_request" {
#   description = "Persistence storage space for Jenkins Controller PVC in K8S cluster"
#   type        = string
#   default     = "250Gi"
# }

# variable "jenkins_hostname" {
#   description = "Jenkins hostname"
#   type        = string
# }

# variable "vault_address" {
#   description = "Vault server address"
#   type        = string
#   default     = ""
# }

# # variable "vault_token" {
# #   description = "Vault token"
# #   type        = string
# #   default     = null
# # }
