


provider "kubernetes" {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1"
      command = "aws"
      args = [ 
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_id,
        "--region",
        "us-east-1",
        "--role-arn",
        "arn:aws:iam::734237051973:role/RolePowerUserAccess"
        ]

      env = {
        "name" = "AWS_PROFILE"
        "value" ="personal-1973"
      }

    }
}
