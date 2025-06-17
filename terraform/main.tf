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
  subnet_cidr  = "10.0.0.0/16"
  region       = "us-west1"
}

output "vpc_id" {
  description = "ID of the VPC network from the network module"
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "ID of the subnetwork from the network module"
  value       = module.network.subnet_id
}
