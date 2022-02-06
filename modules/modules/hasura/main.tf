resource "kubernetes_deployment" "hasura_deployment" {
  metadata {
    namespace = var.namespace
    name      = "hasura-deployment"
    labels    = {
      app = "hasura_deployment"
    }
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = "hasura_deployment"
      }
    }
    template {
      metadata {
        labels = {
          app = "hasura_deployment"
        }
      }
      spec {
        container {
          image = "hasura/graphql-engine"
          image_pull_policy = "IfNotPresent"
          name  = "hasura"

          port {
            container_port = var.hasura_graphql_server_port
          }

          env {
            name  = "HASURA_GRAPHQL_ENABLE_CONSOLE"
            value = var.hasura_graphql_enable_console
          }

          env {
            name  = "HASURA_GRAPHQL_DEV_MODE"
            value = var.hasura_graphql_dev_mode
          }

          env {
            name  = "HASURA_GRAPHQL_DATABASE_URL"
            value = var.hasura_graphql_database_url
          }

          env {
            name  = "HASURA_GRAPHQL_ADMIN_SECRET"
            value = var.hasura_graphql_admin_secret
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hasura_cluster_ip" {
  metadata {
    namespace = var.namespace
    name      = "hasura-cluster-ip"
    labels    = {
      app = "hasura_cluster_ip"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.hasura_deployment.metadata[0].labels.app
    }
    port {
      port        = var.hasura_graphql_server_port
      target_port = var.hasura_graphql_server_port
    }

    type = "ClusterIP"
  }
}
