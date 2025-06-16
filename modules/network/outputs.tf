output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "vpc_self_link" {
  description = "Self-link URL of the VPC network"
  value       = google_compute_network.vpc.self_link
}