terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.19"
    }

    helm = {
      source = "hashicorp/helm"
      version =  "2.17.0"
    }
        
  }
   required_version = ">= 1.11.0"
}
