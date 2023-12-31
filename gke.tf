#module
#using separately managed node pool 
# ref https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster

resource "google_service_account" "default" {
  account_id   = "terraform"
  display_name = "Terraform admin account"
}

resource "google_container_cluster" "gke-cluster" {
  name = "gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count = 1
  network = google_compute_network.vpc_network.id
  network_policy {
    enabled = true
    provider = "CALICO"
  }
  subnetwork = google_compute_subnetwork.network.id
  
  ip_allocation_policy {
    cluster_secondary_range_name = "tf-subnet-range-2"
    services_secondary_range_name = google_compute_subnetwork.network.secondary_ip_range.0.range_name
  }
}

timeouts {
  create = "30m"
  update = "40m"
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = google_container_cluster.gke-cluster.name
  location   = "us-central1"
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 2
  labels = {
    developer = "deveng"
  }
  metadata = {
    disable-legacy-endpoints = "true"
  }


  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"
  }
  depends_on = [google_container_cluster.gke-cluster]
}