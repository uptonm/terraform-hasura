resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    namespace = var.namespace
    name      = "postgres-pvc"
    labels    = {
      app = "postgres_pvc"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "postgres_deployment" {
  metadata {
    namespace = var.namespace
    name      = "postgres-deployment"
    labels    = {
      app = "postgres_deployment"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres_deployment"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres_deployment"
        }
      }
      spec {
        volume {
          name = "pg-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
        container {
          image = "postgres:14.1"
          image_pull_policy = "IfNotPresent"
          name  = "postgres"

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "pg-storage"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgres"
          }

          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_user
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres_cluster_ip" {
  metadata {
    namespace = var.namespace
    name      = "postgres-cluster-ip"
    labels    = {
      app = "postgres_cluster_ip"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.postgres_deployment.metadata[0].labels.app
    }
    port {
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"
  }
}
