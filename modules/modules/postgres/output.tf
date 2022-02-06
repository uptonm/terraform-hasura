output "postgres_connection_url" {
  value = "postgres://${var.postgres_user}:${var.postgres_password}@${kubernetes_service.postgres_cluster_ip.metadata[0].name}:${kubernetes_service.postgres_cluster_ip.spec[0].port[0].port}/${var.postgres_db}"
}
