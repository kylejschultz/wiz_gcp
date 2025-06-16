variable "project_id" {
    description = "GCP Project ID"
    type = string
}

provider "google" {
  project = var.project_id
  region = "us-west1"
  zone = "us-west1-a"
}

module "network" {
  source       = "./modules/network"
  network_name = "wiz-vpc"
}

output "vpc_id" {
  description = "ID of the VPC network from the network module"
  value       = module.network.vpc_id
}