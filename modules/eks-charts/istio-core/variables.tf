

variable "istio_core_chart" {
    type = string
    default = "base"
}

variable "istio_core_repository" {
  type = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_core_version" {
  type = string
  default = "1.20.7"
}



variable "istio_base_repository" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_base_chart" {
  type    = string
  default = "base"
}

variable "istio_base_version" {
  type = string
  #default = "1.12.7"
  default = "1.17.8"
}

variable "image_hub" {
  type        = string
  description = "Image repository"
  default     = "gcr.io/istio-release"
}

variable "istiod_repository" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istiod_chart" {
  type    = string
  default = "istiod"
}

variable "istiod_version" {
  type    = string
  default = "1.17.8"
}

variable "istiod_min_replicas" {
  type    = string
  default = "2"
}

variable "istiod_instance_type" {
  type    = string
  default = "t3.medium"
}


variable "cpu_requests_istiod" {
  type        = string
  description = "cpu requests for istiod"
  default     = "0.5"
}

variable "memory_requests_istiod" {
  type        = string
  description = "memory requests for istiod"
  default     = "1Gi"
}

variable "team_name" {
  type        = string
  description = "name of the service team"
  default     = "team-infra"
}


variable "istio_sidecar_repository" {
  type    = string
  default = "https://raw.githubusercontent.com/itscontained/charts/gh-pages"
}

variable "istio_sidecar" {
  type    = string
  default = "raw"
}

variable "istio_sidecar_version" {
  type    = string
  default = "0.2.5"
}
