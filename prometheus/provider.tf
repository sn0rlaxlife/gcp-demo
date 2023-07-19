terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.74.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
 }
    }

data "google_client_config" "provider" {}

data "google_container_cluster" "gke-cluster" {
  name     = "gke-cluster"
  location = "us-central1"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "kubectl" {
  config_path = "~/.kube/config"

}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"

  }
}
}