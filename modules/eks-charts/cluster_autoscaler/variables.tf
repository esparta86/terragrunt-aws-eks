variable "logtostderr" {
  type    = bool
  default = true
}

variable "stderrthreshold" {
  type    = string
  default = "info"
}

variable "v" {
  type    = number
  default = 4
}

variable "extra_args" {
  type        = map(string)
  description = "Cluster autoscaler CLI extra arguments. Without trailing `--`."
  default     = {}
}

variable "cluster_name" {   
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "service_account_name" {
  description = "The name of the service account for the cluster autoscaler"
  type        = string
#   default     = "cluster-autoscaler"
}

variable "cluster_autoscaler_repository" {
  type        = string
  description = "Helm chart repository for cluster-autoscaler"
  default     = "https://kubernetes.github.io/autoscaler"
}

variable "cluster_autoscaler_chart" {
  type        = string
  description = "Helm chart name for cluster-autoscaler"
  default     = "cluster-autoscaler"
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Helm chart version for cluster autoscaler"
  default     = "9.44.0"
}

variable "pod_labels" {
  type        = map(string)
  description = "Additional labels to add to pods. Used by deployment-pod-selector too! Do not add labels with changing/dynamic values here!"
  default     = {}
}

variable "additional_labels" {
  type        = map(string)
  description = "Additional labels to add to everything"
  default     = {}
}

variable "resources" {
  type = map(object({
    cpu    = string
    memory = string
  }))

  description = "If you want define request, limit of resources"
  default     = {}
}


variable "replica_count" {
  type        = number
  description = "Number of replicas for cluster-autoscaler"
  default     = 1
}


variable "image_repository" {
  type        = string
  description = "Cluster-autoscaler image repository"
  default     = "registry.k8s.io/autoscaling/cluster-autoscaler"
}


variable "cluster_autoscaler_version" {
  type        = string
  description = "cluster-autoscaler docker version"
  # default     = "v1.28.2"
  default     = "v1.31.0"
}

variable "aws_region" {
  type        = string
  description = "AWS region of EKS cluster"
}


variable "expander_priorities" {
  description = "A map of priority values to regular expressions for Cluster Autoscaler node group prioritization. Keys are priority numbers, values are lists of regex strings."
  type        = map(list(string))
  # default     = {} 
}

variable "expander_strategy" {
  description = "The expander strategy for Cluster Autoscaler (e.g., 'priority', 'most-pods', 'least-waste')."
  type        = string
  default     = "least-waste"
}
