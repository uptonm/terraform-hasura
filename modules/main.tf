resource "kubernetes_namespace" "development_namespace" {
  metadata {
    name = var.environment_namespace
  }
}

module "postgres" {
  source = "./modules/postgres"


  postgres_db       = var.postgres_db
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password
  namespace         = kubernetes_namespace.development_namespace.metadata[0].name
}

module "hasura" {
  source = "./modules/hasura"


  hasura_graphql_dev_mode       = var.hasura_graphql_dev_mode
  hasura_graphql_enable_console = var.hasura_graphql_dev_mode
  hasura_graphql_admin_secret   = var.hasura_graphql_admin_secret
  hasura_graphql_database_url   = module.postgres.postgres_connection_url
  namespace                     = kubernetes_namespace.development_namespace.metadata[0].name
}

resource "kubernetes_manifest" "ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata"   = {
      "annotations" = {
        "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      }
      "name"        = "hasura-ingress"
      "namespace"   = kubernetes_namespace.development_namespace.metadata[0].name
    }
    spec         = {
      rules = [
        {
          host = var.hasura_graphql_url
          http = {
            paths = [
              {
                path     = "/"
                pathType = "Prefix"
                backend  = {
                  service = {
                    name = module.hasura.hasura_cluster_ip_service_host,
                    port = {
                      number = 8080
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
}
