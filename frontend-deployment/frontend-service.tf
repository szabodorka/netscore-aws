resource "kubernetes_service" "ns_frontend" {
  metadata {
    name = "${var.project_name}-frontend-service"
    labels = {
      app = "${var.project_name}-frontend"
    }
  }
  spec {
    selector = {
      app = "${var.project_name}-frontend"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.ns_frontend]
}
