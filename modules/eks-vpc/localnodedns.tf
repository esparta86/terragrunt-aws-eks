# locals {
#   value_files = [
#     var.values_override_file
#   ]
# }

# resource "helm_release" "nodelocaldns" {
#   count             = var.values_override_file != null && length(var.values_override_file) > 0 ? 1 : 0
#   name              = "nodelocaldns"
#   namespace         = "kube-system"
#   repository        = "https://charts.deliveryhero.io"
#   chart             = "node-local-dns"
#   version           = "1.1.3"
#   create_namespace  = false
#   dependency_update = false
#   atomic            = true
#   timeout           = 1800
#   values            = [for value_file in local.value_files : file(value_file) if value_file != null]
# }
