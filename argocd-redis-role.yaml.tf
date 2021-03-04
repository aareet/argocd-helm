resource "kubernetes_manifest" "role_argocd_redis" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "Role"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "redis"
        "app.kubernetes.io/name"      = "argocd-redis"
        "app.kubernetes.io/part-of"   = "argocd"
      }
      "name"      = "argocd-redis"
      "namespace" = kubernetes_manifest.namespace_argocd.object.metadata.name
    }
    "rules" = [
      {
        "apiGroups" = [
          "security.openshift.io",
        ]
        "resourceNames" = [
          "nonroot",
        ]
        "resources" = [
          "securitycontextconstraints",
        ]
        "verbs" = [
          "use",
        ]
      },
    ]
  }
}
