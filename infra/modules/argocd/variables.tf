variable "version_chart" {
  description = "Version du chart Helm ArgoCD"
  type        = string
}

variable "depot" {
  description = "URL HTTPS repo Git avec les manifests"
  type        = string
}
