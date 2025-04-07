resource "kubernetes_manifest" "service_argocd_argocd_server_nodeport" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "annotations" = null
      "labels" = {
        "app.kubernetes.io/component" = "server"
        "app.kubernetes.io/name" = "argocd-server"
        "app.kubernetes.io/part-of" = "argocd"
      }
      "name" = "argocd-server-nodeport"
      "namespace" = "argocd"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "nodePort" = 30007
          "port" = 80
          "protocol" = "TCP"
          "targetPort" = 8080
        },
        {
          "name" = "https"
          "nodePort" = 30008
          "port" = 443
          "protocol" = "TCP"
          "targetPort" = 8080
        },
      ]
      "selector" = {
        "app.kubernetes.io/name" = "argocd-server"
      }
      "type" = "NodePort"
    }
  }
}
