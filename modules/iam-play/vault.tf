#####################################
#   Vault policy                    #
#####################################

# data "vault_policy_document" "jenkins_policy_hcl" {
#   rule {
#     path         = "${var.mount_point}/data/ste/${var.environment}/jenkins/*"
#     capabilities = ["read", "list"]
#     description  = "allow read on self secrets"
#   }
#   rule {
#     path         = "${var.mount_point}/metadata/ste/${var.environment}/jenkins/*"
#     capabilities = ["read", "list"]
#     description  = "allow read on self secrets"
#   }
#   rule {
#     path         = "secret/data/devops/k8s/clusters/${var.cluster_name}"
#     capabilities = ["read", "list"]
#     description  = "allow read on self secrets"
#   }
#   rule {
#     path         = "secret/metadata/devops/k8s/clusters/${var.cluster_name}"
#     capabilities = ["read", "list"]
#     description  = "allow read on self secrets"
#   }
# }

# resource "vault_policy" "jenkins_policy" {
#   name   = "${var.environment}-jenkins-policy"
#   policy = data.vault_policy_document.jenkins_policy_hcl.hcl
# }

#####################################
#   Vault backends                  #
#####################################

# resource "vault_kubernetes_auth_backend_role" "jenkins_poc" {
#   backend                          = var.cluster_name
#   role_name                        = "jenkins-k8s-${var.environment}"
#   bound_service_account_names      = [var.jenkins_controller_service_account]
#   bound_service_account_namespaces = [var.jenkins_namespace]
#   token_ttl                        = 3600
#   token_policies                   = ["default", vault_policy.jenkins_policy.name]
# }
