output "db_vm_name" {
  description = "The name of the DB VM instance"
  value       = google_compute_instance.db_vm.name
}

output "db_vm_internal_ip" {
  description = "Internal IP address of the DB VM"
  value       = google_compute_instance.db_vm.network_interface[0].network_ip
}

output "db_vm_self_link" {
  description = "Self-link of the DB VM"
  value       = google_compute_instance.db_vm.self_link
}
