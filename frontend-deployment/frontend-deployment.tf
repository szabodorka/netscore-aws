resource "kubernetes_deployment" "ns_frontend" {
  metadata {
    name = "${var.project_name}-frontend"
    labels = {
      app = "${var.project_name}-frontend"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "${var.project_name}-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.project_name}-frontend"
        }
      }

      spec {
        container {
          image = var.image
          name  = "${var.project_name}-frontend"
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "150m"
              memory = "50Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 5
            period_seconds        = 5
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}