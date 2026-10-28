variable "nom_cluster" {
  description = "cluster Kind"
  type        = string
}

variable "version_argocd" {
  description = "Version du chart Helm Argo CD"
  type        = string
}

variable "depot" {
  description = "URL HTTPS Repo Git avec les manifests"
  type        = string
}
