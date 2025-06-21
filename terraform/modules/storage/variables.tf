variable "bucket_name" {
  description = "Name of the GCS bucket for DB backups"
  type        = string
}

variable "location" {
  description = "GCS bucket location (region)"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}
