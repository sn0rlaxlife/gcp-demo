#provision a vpc

resource "google_compute_subnetwork" "network" {
    name          = "terraform-subnetwork"
    ip_cidr_range = "10.2.0.0/16"
    region        = "us-central1"
    network       = google_compute_network.vpc_network.name
    secondary_ip_range  {
        range_name    = "tf-subnet-range"
        ip_cidr_range = "192.168.1.0/24"
    }

    secondary_ip_range {
        range_name    = "tf-subnet-range-2"
        ip_cidr_range = "192.168.64.0/22"
    }
}

resource "google_compute_network" "vpc_network" {
    name                    = "terraform-network"
    auto_create_subnetworks = false
}

