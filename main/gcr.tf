resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "gcr_base" {
  location      = "us"
  repository_id = "gcr.io"
  description   = "Base Docker repository for gcr.io alias"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }

  labels = {
    environment = "non-production"
    application = "gcr-base"
  }

  depends_on = [google_project_service.artifact_registry]
}

output "artifact_registry_base_url" {
  description = "Base Docker Artifact Registry URL for this project"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}"
}

output "artifact_registry_gcr_base_repo" {
  description = "Artifact Registry repo for the gcr.io alias"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.gcr_base.repository_id}"
}

output "gcr_base_repo_alias" {
  description = "Legacy gcr.io alias for the artifact registry repo"
  value       = "gcr.io/${var.project_id}/${google_artifact_registry_repository.gcr_base.repository_id}"
}

output "gcr_base_url" {
  description = "Legacy gcr.io base URL alias for this project"
  value       = "gcr.io/${var.project_id}"
}

output "gcr_us_base_url" {
  description = "Legacy us.gcr.io base URL alias for this project"
  value       = "us.gcr.io/${var.project_id}"
}
