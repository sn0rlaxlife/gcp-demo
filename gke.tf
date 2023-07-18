#module

default "google_client_config" "default" {}

module "kubernetes-engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "27.0.0"
  # insert the 6 required variables here
}

provider "kubernetes" {
    host                    = "https://${module.kubernetes-engine.endpoint}"
    username               = "${module.kubernetes-engine.username}"
    password               = "${module.kubernetes-engine.password}"
    client_certificate     = "${base64decode(module.kubernetes-engine.client_certificate)}"

}

module "gke" {
    source                             = "terraform-google-modules/kubernetes-engine/google"
    project_id                         = var.project_id
    name                               = var.name
    region                             = var.region
    zones                              = var.zones
    network                            = var.network
    subnetwork                         = var.subnetwork
    ip_range_pods                      = var.ip_range_pods
    ip_range_services                  = var.ip_range_services
    http_load_balancing_enabled        = var.http_load_balancing_enabled
    horizontal_pod_autoscaling_enabled = var.horizontal_pod_autoscaling_enabled
    network_policy_enabled             = var.network_policy_enabled
    filestore_csi_driver_enabled       = var.filestore_csi_driver_enabled
  node_pools = [
    {
        name               = var.node_pools_name
        machine_type       = var.node_pools_machine_type
        min_count          = var.node_pools_min_count
        max_count          = var.node_pools_max_count
        local_ssd_count    = var.node_pools_local_ssd_count
        spot               = var.node_pools_spot
        disk_size_gb       = var.node_pools_disk_size_gb
        disk_type          = var.node_pools_disk_type
        image_type         = var.node_pools_image_type
        enable_gcfs        = var.node_pools_enable_gcfs
        enable_gvnic       = var.node_pools_enable_gvnic
        auto_repair        = var.node_pools_auto_repair
        auto_upgrade       = var.node_pools_auto_upgrade
        service_account    = var.node_pools_service_account
        preemptible        = var.node_pools_preemptible
        initial_node_count = var.node_pools_initial_node_count
    }
  ]
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
