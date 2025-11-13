resource "kubernetes_ingress_v1" "ns_frontend" {
  metadata {
    name                                       = "${var.project_name}-frontend-ingress"
    annotations = {
      "kubernetes.io/ingress.class"            = "alb"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"  = "ip"
      "alb.ingress.kubernetes.io/group.name"   = "netscore-alb"
      "alb.ingress.kubernetes.io/group.order"  = "20"
    }

    labels = {
      app = var.project_name
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.ns_frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.ns_frontend]
}
