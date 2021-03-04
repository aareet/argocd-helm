resource "kubernetes_manifest" "service_argocd_dex_server" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "dex-server"
        "app.kubernetes.io/name"      = "argocd-dex-server"
        "app.kubernetes.io/part-of"   = "argocd"
      }
      "name"      = "argocd-dex-server"
      "namespace" = kubernetes_manifest.namespace_argocd.object.metadata.name
    }
    "spec" = {
      "ports" = [
        {
          "name"       = "http"
          "port"       = 5556
          "protocol"   = "TCP"
          "targetPort" = 5556
        },
        {
          "name"       = "grpc"
          "port"       = 5557
          "protocol"   = "TCP"
          "targetPort" = 5557
        },
        {
          "name"       = "metrics"
          "port"       = 5558
          "protocol"   = "TCP"
          "targetPort" = 5558
        },
      ]
      "selector" = {
        "app.kubernetes.io/name" = "argocd-dex-server"
      }
    }
  }
}
