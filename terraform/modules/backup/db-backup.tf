resource "google_service_account" "scheduler_invoker" {
  account_id   = "scheduler-invoker"
  display_name = "Pub/Sub invoker for Mongo backup builds"
}

resource "google_pubsub_topic" "mongo_backup" {
  name    = "mongo-backup-topic"
  project = var.project_id
}

resource "google_pubsub_topic_iam_member" "build_subscriber" {
  topic  = google_pubsub_topic.mongo_backup.name
  role   = "roles/pubsub.subscriber"
  member = "serviceAccount:${google_service_account.scheduler_invoker.email}"
}

resource "google_cloudbuild_trigger" "mongo_backup" {
  name = "mongo-backup-trigger"

  pubsub_config {
    topic                 = google_pubsub_topic.mongo_backup.id
    service_account_email = google_service_account.scheduler_invoker.email
  }

  filename = "terraform/modules/backup/cloudbuild.yaml"
  substitutions = {
    _MONGO_HOST = var.mongo_host
    _MONGO_USER = var.mongo_user
    _MONGO_PASS = var.mongo_pass
    _BUCKET     = var.bucket
  }
}

resource "google_cloud_scheduler_job" "mongo_backup_job" {
  name      = "mongo-backup-job"
  schedule  = "0 */4 * * *" # every 4 hours
  time_zone = "America/Los_Angeles"

  pubsub_target {
    topic_name = google_pubsub_topic.mongo_backup.id
    data       = base64encode("{}") # empty JSON payload
  }
}
