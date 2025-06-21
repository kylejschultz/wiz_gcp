variable "project_id" {
  description = "GCP Project ID where Container Registry and IAM bindings will be configured"
  type        = string
}

variable "github_actions_sa" {
  description = "Email of the GitHub Actions service account for pushing images to GCR"
  type        = string
}
