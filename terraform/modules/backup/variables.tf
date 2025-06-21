variable "mongo_host" {
  description = "Internal IP or hostname of your Mongo VM"
  type        = string
}

variable "mongo_user" {
  description = "MongoDB admin username"
  type        = string
}

variable "mongo_pass" {
  description = "MongoDB admin password"
  type        = string
}

variable "bucket" {
  description = "Name of the GCS bucket for backups"
  type        = string
}

variable "pubsub_topic" {
  description = "ID of the Pub/Sub topic for triggering MongoDB backups"
  type        = string
}
