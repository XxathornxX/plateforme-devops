variable "nom_cluster" {
  description = "Nom du cluster Kind."
  type        = string
}

variable "version_argocd" {
  description = "Version du chart Helm Argo CD à installer."
  type        = string
}
