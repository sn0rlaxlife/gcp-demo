terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }

   provider "google" {
  # Configuration options
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
}