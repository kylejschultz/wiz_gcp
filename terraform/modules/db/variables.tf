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

variable "network" {
  description = "Self-link or ID of the VPC network"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range of the VPC subnetwork for MongoDB firewall"
  type        = string
}

variable "pod_cidr" {
  description = "Secondary Pod IP range CIDR from GKE"
  type        = string
}

variable "service_account_email" {
  description = "Service account email for the DB VM to authenticate GCS uploads"
  type        = string
}
