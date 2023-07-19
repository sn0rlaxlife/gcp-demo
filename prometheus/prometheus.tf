provider "kubectl" {
  config_path = "~/.kube/config"

}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"

  }
}
resource "helm_release" "prometheus" {
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  create_namespace = "true"
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
}

