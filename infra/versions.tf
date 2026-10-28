terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.13.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}