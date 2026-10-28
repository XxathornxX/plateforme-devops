resource "kind_cluster" "plateforme" {
  name           = "plateforme"
  wait_for_ready = true
}

provider "helm" {
  kubernetes = {
    host                   = kind_cluster.plateforme.endpoint
    cluster_ca_certificate = kind_cluster.plateforme.cluster_ca_certificate
    client_certificate     = kind_cluster.plateforme.client_certificate
    client_key             = kind_cluster.plateforme.client_key
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "10.10.3"
  create_namespace = true
  timeout          = 600
}