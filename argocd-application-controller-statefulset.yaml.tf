resource "kubernetes_manifest" "statefulset_argocd_application_controller" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "StatefulSet"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "application-controller"
        "app.kubernetes.io/name" = "argocd-application-controller"
        "app.kubernetes.io/part-of" = "argocd"
      }
      "name" = "argocd-application-controller"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app.kubernetes.io/name" = "argocd-application-controller"
        }
      }
      "serviceName" = "argocd-application-controller"
      "template" = {
        "metadata" = {
          "labels" = {
            "app.kubernetes.io/name" = "argocd-application-controller"
          }
        }
        "spec" = {
          "affinity" = {
            "podAntiAffinity" = {
              "preferredDuringSchedulingIgnoredDuringExecution" = [
                {
                  "podAffinityTerm" = {
                    "labelSelector" = {
                      "matchLabels" = {
                        "app.kubernetes.io/name" = "argocd-application-controller"
                      }
                    }
                    "topologyKey" = "kubernetes.io/hostname"
                  }
                  "weight" = 100
                },
                {
                  "podAffinityTerm" = {
                    "labelSelector" = {
                      "matchLabels" = {
                        "app.kubernetes.io/part-of" = "argocd"
                      }
                    }
                    "topologyKey" = "kubernetes.io/hostname"
                  }
                  "weight" = 5
                },
              ]
            }
          }
          "containers" = [
            {
              "command" = [
                "argocd-application-controller",
                "--status-processors",
                "20",
                "--operation-processors",
                "10",
              ]
              "image" = "argoproj/argocd:v1.8.6"
              "imagePullPolicy" = "Always"
              "livenessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8082
                }
                "initialDelaySeconds" = 5
                "periodSeconds" = 10
              }
              "name" = "argocd-application-controller"
              "ports" = [
                {
		  "protocol" = "TCP"
                  "containerPort" = 8082
                },
              ]
              "readinessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8082
                }
                "initialDelaySeconds" = 5
                "periodSeconds" = 10
              }
            },
          ]
          "serviceAccountName" = "argocd-application-controller"
        }
      }
    }
  }
}
