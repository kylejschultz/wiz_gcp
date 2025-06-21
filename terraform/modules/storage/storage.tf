resource "google_storage_bucket" "backups" {
  name                        = var.bucket_name
  location                    = var.location
  project                     = var.project_id
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.backups.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
