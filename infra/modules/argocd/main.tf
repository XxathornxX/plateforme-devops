resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = var.version_chart
  create_namespace = true
  timeout          = 600
}

resource "helm_release" "argocd_apps" {
  depends_on       = [helm_release.argocd]
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  namespace        = "argocd"
  version          = "2.0.6"
  create_namespace = false

  values = [
    yamlencode({
      applications = {
        racine = {
          namespace = "argocd"
          project   = "default"
          source = {
            repoURL        = var.depot
            targetRevision = "main"
            path           = "deploy/argocd"
          }
          destination = {
            server    = "https://kubernetes.default.svc"
            namespace = "argocd"
          }
          syncPolicy = {
            automated = {}
          }
        }
      }
    })
  ]
}
