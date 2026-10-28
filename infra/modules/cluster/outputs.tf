output "endpoint" {
  value = kind_cluster.plateforme.endpoint
}

output "cluster_ca_certificate" {
  value     = kind_cluster.plateforme.cluster_ca_certificate
  sensitive = true
}

output "client_certificate" {
  value     = kind_cluster.plateforme.client_certificate
  sensitive = true
}

output "client_key" {
  value     = kind_cluster.plateforme.client_key
  sensitive = true
}
