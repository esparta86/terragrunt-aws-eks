

#  Credential file  should has the key and access key id as default profile using the aws account that you want to execute it.
provider "kubernetes" {
    
    
    host = module.eks[0].cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks[0].cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1"
      command = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks[0].cluster_name,
        "--region",
        "us-east-1",
        "--role",
        "arn:aws:iam::${var.aws_account_id}:role/RolePowerUserAccess"
        ]

      # env = {
      #   "name" = "AWS_PROFILE"
      #   "value" ="personal-1973"
      # }

    }
}


# resource "kubernetes_namespace" "istio_system" {
#   metadata {
#     name = "istio-system"
#     # labels = {
#     #   "istio-injection" = "enabled"
#     # }
#   }
# }


# resource "kubernetes_namespace" "istio_system" {
#   metadata {
#     name = "istio-system"
#     labels = {
#       "istio-injection" = "enabled"
#     }
#   }
# }

# resource "helm_release" "istio_base" {
#   name             = "istio-base"
#   namespace        = "istio-system"
#   repository       = var.istio_base_repository
#   chart            = var.istio_base_chart
#   version          = var.istio_base_version
#   create_namespace = false
#   atomic           = true

#   depends_on = [
#     kubernetes_namespace.istio_system
#   ]

#   values = [yamlencode({
#     "global" : {
#       "hub" : "${var.image_hub}"
#     }
#   })]
# }


# resource "helm_release" "istiod" {
#   name             = "istiod"
#   namespace        = "istio-system"
#   repository       = var.istiod_repository
#   chart            = var.istiod_chart
#   version          = var.istiod_version
#   create_namespace = false
#   atomic           = true

#   depends_on = [
#     kubernetes_namespace.istio_system,
#     helm_release.istio_base
#   ]
# # "revision": "${replace(var.istiod_version,".","-")}"
#   values = [yamlencode({
#     "global" : {
#       "tag" : "${var.istiod_version}"
#       "hub" : "${var.image_hub}",
#       "priorityClassName" : "system-node-critical",
#       "logAsJson" : true,
#       "proxy" : {
#         "lifecycle" : {
#           "preStop" : {
#             "exec" : {
#               "command" : [
#                 "/bin/sh",
#                 "-c",
#                 "curl -X POST localhost:15000/drain_listeners?inboundonly; while [ $(netstat -plunt | grep tcp | grep -v envoy | grep -v pilot-agent | wc -l | xargs) -ne 0 ]; do sleep 1; done"
#               ]
#             }
#           }
#         }
#       }
#     },
#     "meshConfig" : {
#       "extensionProviders" : [{
#         "name" : "zipkintrace",
#         "zipkin" : {
#           "service" : "otel-collector.opentelemetry-system.svc.cluster.local",
#           "port" : "9411"
#         }
#       }],
#       "defaultProviders" : {
#         "tracing" : [
#           "zipkintrace"
#         ]
#       },
#       "enablePrometheusMerge" : true,
#       "rootNamespace" : "istio-system",
#       "outboundTrafficPolicy" : {
#         "mode" : "ALLOW_ANY"
#       }
#     },
#     "nodeSelector" : {
#       "node.kubernetes.io/instance-type" : "${var.istiod_instance_type}"
#     },
#     "pilot" : {
#       "autoscaleMin" : var.istiod_min_replicas,
#       "autoscaleMax" : "500",
#       "replicaCount" : "2",
#       "rollingMaxSurge" : "10%",
#       "rollingMaxUnavailable" : "10%",
#       "resources" : {
#         "requests" : {
#           "cpu" : var.cpu_requests_istiod,
#           "memory" : var.memory_requests_istiod
#         }
#       },
#       "env" : {
#         "PILOT_PUSH_THROTTLE" : "600",
#         "PILOT_DEBOUNCE_AFTER" : "200ms",
#         "PILOT_DEBOUNCE_MAX" : "10s",
#         "PILOT_ENABLE_CONFIG_DISTRIBUTION_TRACKING" : "false",
#         "PILOT_STATUS_MAX_WORKERS" : "200",
#         "PILOT_STATUS_UPDATE_INTERVAL" : "200ms",
#         "ENABLE_DEBUG_ON_HTTP" : "false",
#         "TERMINATION_DRAIN_DURATION_SECONDS" : "30s"
#       },
#       "podLabels" : {
#         "team-name" : "${var.team_name}",
#         "tags.datadoghq.com/env" : "dev",
#         "tags.datadoghq.com/service" : "istiod",
#         "tags.datadoghq.com/version" : "${var.istiod_version}"
#       },
#       "podAnnotations" : {
#         "ad.datadoghq.com/discovery.check_names" : "[\"istio\"]",
#         "ad.datadoghq.com/discovery.init_configs" : "[{}]",
#         "ad.datadoghq.com/discovery.instances" : "[ \n  { \n   \"istiod_endpoint\" : \"http://%%host%%:15014/metrics\", \n    \"send_histograms_buckets\" : true \n  } \n] \n",
#         "ad.datadoghq.com/discovery.logs" : "{ \"source\": \"istio\", \"service\": \"istiod\"}"
#       },
#     }
#   })]
# }

