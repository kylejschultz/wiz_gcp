variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "network_id" {
  description = "ID of the VPC network to use"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnetwork to use"
  type        = string
}

variable "region" {
  description = "GCP region for the cluster control plane"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
}

variable "node_machine_type" {
  description = "Machine type for the nodes"
  type        = string
}
