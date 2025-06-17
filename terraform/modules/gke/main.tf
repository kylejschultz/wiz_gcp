terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  network                  = var.network_id
  subnetwork               = var.subnet_id
  remove_default_node_pool = true
  initial_node_count       = var.node_count
  deletion_protection      = false
}

resource "google_container_node_pool" "default" {
  name     = "${var.cluster_name}-pool"
  cluster  = google_container_cluster.primary.name
  location = var.region

  node_config {
    machine_type = var.node_machine_type
  }
  initial_node_count = var.node_count
}

output "cluster_name" {
  description = "Name of the created GKE cluster"
  value       = google_container_cluster.primary.name
}

output "endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}
