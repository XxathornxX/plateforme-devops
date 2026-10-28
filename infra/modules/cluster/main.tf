resource "kind_cluster" "plateforme" {
  name           = var.nom
  wait_for_ready = true
}
