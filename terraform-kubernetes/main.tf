resource "kubernetes_manifest" "deployment_youtube_terraform" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "annotations" = {
        "prometheus.io/path" = "/metrics"
        "prometheus.io/port" = "ledport"
        "prometheus.io/scrape" = "true"
      }
      "labels" = {
        "name" = "youtube-terraform"
        "release" = "prometheus"
      }
      "name" = "youtube-terraform"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "youtube-terraform"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "youtube-terraform"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "linuxrobotgeek/youtube-terraform:latest"
              "imagePullPolicy" = "Always"
              "name" = "youtube-terraform"
              "ports" = [
                {
                  "containerPort" = 5000
                  "name" = "ledport"
                  "protocol" = "TCP"
                },
              ]
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_youtube_terraform" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app" = "youtube-terraform"
      }
      "name" = "youtube-terraform"
      "namespace" = "default"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "youtube-terraform"
          "port" = 5000
          "protocol" = "TCP"
          "targetPort" = "ledport"
        },
      ]
      "selector" = {
        "app" = "youtube-terraform"
      }
      "type" = "LoadBalancer"
    }
  }
}

resource "kubernetes_manifest" "servicemonitor_monitoring_youtube_terraform" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind" = "ServiceMonitor"
    "metadata" = {
      "labels" = {
        "app" = "youtube-terraform"
        "release" = "prometheus"
      }
      "name" = "youtube-terraform"
      "namespace" = "monitoring"
    }
    "spec" = {
      "endpoints" = [
        {
          "interval" = "15s"
          "path" = "/metrics"
          "port" = "youtube-terraform"
        },
      ]
      "namespaceSelector" = {
        "matchNames" = [
          "default",
        ]
      }
      "selector" = {
        "matchLabels" = {
          "app" = "youtube-terraform"
        }
      }
    }
  }
}
