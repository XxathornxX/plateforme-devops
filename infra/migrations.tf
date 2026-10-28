moved {
  from = kind_cluster.plateforme
  to   = module.cluster.kind_cluster.plateforme
}

moved {
  from = helm_release.argocd
  to   = module.argocd.helm_release.argocd
}
