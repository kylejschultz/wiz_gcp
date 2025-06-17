output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "vpc_self_link" {
  description = "Self-link URL of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "ID of the subnetwork"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_self_link" {
  description = "Self-link URL of the subnetwork"
  value       = google_compute_subnetwork.subnet.self_link
}
