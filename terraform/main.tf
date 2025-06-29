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

module "db" {
  source                = "./modules/db"
  instance_name         = "wiz-db"
  zone                  = "us-west1-a"
  machine_type          = "e2-medium"
  network               = module.network.vpc_id
  subnetwork            = module.network.subnet_self_link
  subnet_cidr           = "10.0.0.0/16"
  pod_cidr              = "10.8.0.0/14"
  network_tags          = ["db"]
  service_account_email = "github-deployer@clgcporg10-155.iam.gserviceaccount.com"
}

module "storage" {
  source      = "./modules/storage"
  bucket_name = "wiz-db-backups-${var.project_id}"
  location    = "us-west1"
  project_id  = var.project_id
}

module "gcr" {
  source            = "./modules/gcr"
  project_id        = var.project_id
  github_actions_sa = "github-deployer@${var.project_id}.iam.gserviceaccount.com"
}
