variable "instance_name" {
  description = "Name of the DB VM"
  type        = string
}

variable "zone" {
  description = "GCP zone for the VM"
  type        = string
}

variable "machine_type" {
  description = "Compute engine machine type"
  type        = string
}

variable "subnetwork" {
  description = "Self-link or ID of the subnetwork"
  type        = string
}

variable "network_tags" {
  description = "List of network tags for firewall rules"
  type        = list(string)
  default     = []
}
