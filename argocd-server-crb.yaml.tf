resource "kubernetes_manifest" "clusterrolebinding_argocd_server" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "server"
        "app.kubernetes.io/name"      = "argocd-server"
        "app.kubernetes.io/part-of"   = "argocd"
      }
      "name" = "argocd-server"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind"     = "ClusterRole"
      "name"     = "argocd-server"
    }
    "subjects" = [
      {
        "kind"      = "ServiceAccount"
        "name"      = "argocd-server"
        "namespace" = "argocd"
      },
    ]
  }
}
