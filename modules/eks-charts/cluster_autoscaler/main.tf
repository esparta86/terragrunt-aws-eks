locals {
  extra_args = merge(
    # these 3 args were provided by default, so provisioning them separately and merging with other extra_args
    {
      logtostderr     = var.logtostderr
      stderrthreshold = var.stderrthreshold
      v               = var.v
    },
    var.extra_args
  )
}

resource "helm_release" "cluster_autoscaler" {
  name             = "cluster-autoscaler"
  namespace        = "kube-system"
  repository       = var.cluster_autoscaler_repository
  chart            = var.cluster_autoscaler_chart
  version          = var.cluster_autoscaler_chart_version
  create_namespace = false

  atomic = true

  values = [yamlencode({
    "podAnnotations" : {
      "prometheus.io/scrape" : "true"
      "prometheus.io/port" : "8085"
    },
    "podLabels" : var.pod_labels,
    "extraArgs" : local.extra_args,
    "additionalLabels" : var.additional_labels
    "resources" : var.resources
  })]

  set {
    name  = "replicaCount"
    value = var.replica_count
  }
  set {
    name  = "image.repository"
    value = var.image_repository
  }
  set {
    name  = "image.tag"
    value = var.cluster_autoscaler_version
  }
  set {
    name  = "awsRegion"
    value = var.aws_region
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = var.service_account_name
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_admin.iam_role_arn
    type  = "string"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }
  set {
    name  = "rbac.create"
    value = "true"
  }

  dynamic "set" {
    for_each = var.expander_strategy == "priority" ? [1] : []
    content {
      name  = "expanderPriorities"
      value = replace(yamlencode(var.expander_priorities),"/\"([0-9]+)\":/","$1:")
    }
  }

  set {
    name  = "extraArgs.expander"
    value = var.expander_strategy
  }
}
