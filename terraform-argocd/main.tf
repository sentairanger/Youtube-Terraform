resource "kubernetes_manifest" "application_argocd_youtube_terraform" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "youtube-terraform"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "namespace" = "default"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "path" = "kubernetes"
        "repoURL" = "https://github.com/sentairanger/Youtube-Terraform"
        "targetRevision" = "HEAD"
      }
      "syncPolicy" = {}
    }
  }
}
