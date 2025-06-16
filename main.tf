variable "project_id" {
    description = "GCP Project ID"
    type = string
}

provider "google" {
  project = var.project_id
  region = "us-west1"
  zone = "us-west1-a"
}

data "google_project" "current" {
  project_id = var.project_id
}

output "project_number" {
  description = "Your GCP project number (read‐only)"
  value       = data.google_project.current.number
}