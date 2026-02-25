
variable "cluster_name" {   
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "cluster_autoscaler_service_account_name" {
  description = "The name of the service account for the cluster autoscaler"
  type        = string
  default     = "cluster-autoscaler"
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Helm chart version for cluster autoscaler"
  default     = "9.44.0"
}


  variable "aws_load_balancer_controller_service_account_name" {
  description = "The name of the service account for the AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
  }


variable "enable_aws_lb_controller" {
  description = "Enable AWS Load Balancer Controller installation"
  type        = bool
  default     = true
}
