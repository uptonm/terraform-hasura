output "hasura_console_url" {
  value = "http://${kubernetes_service.hasura_cluster_ip.metadata[0].name}:${var.hasura_graphql_server_port}"
}

output "hasura_graphql_url" {
  value = "http://${kubernetes_service.hasura_cluster_ip.metadata[0].name}:${var.hasura_graphql_server_port}/v1/graphql"
}

output "hasura_cluster_ip_service_host" {
  value = kubernetes_service.hasura_cluster_ip.metadata[0].name
}
