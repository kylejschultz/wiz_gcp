output "bucket_name" {
  description = "Name of the backups bucket"
  value       = google_storage_bucket.backups.name
}

output "bucket_url" {
  description = "Public URL of the backups bucket"
  value       = "https://storage.googleapis.com/${google_storage_bucket.backups.name}/"
}
