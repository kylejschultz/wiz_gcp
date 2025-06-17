terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

provider "google" {
  project = var.project_id
  region  = "us-west1"
  zone    = "us-west1-a"
}

module "network" {
  source       = "./modules/network"
  network_name = "wiz-vpc"
  subnet_cidr  = "10.0.0.0/16"
  region       = "us-west1"
}

module "gke" {
  source            = "./modules/gke"
  cluster_name      = "wiz-cluster"
  region            = "us-west1"
  network_id        = module.network.vpc_id
  subnet_id         = module.network.subnet_id
  node_machine_type = "e2-medium"
  node_count        = 1
}
