variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnetwork"
  type        = string
}

variable "region" {
  description = "GCP region where the subnetwork should reside"
  type        = string
}
