resource "google_service_account" "fraud_sa" {
  account_id   = "fraud-sa"

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "GitHub Actions service account"

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_project_iam_member" "fraud_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:fraud-sa@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "fraud_sa_gke" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:fraud-sa@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "fraud_sa_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:fraud-sa@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "pubsub_access" {
  project = var.project_id
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.fraud_sa.email}"
}

resource "google_project_iam_member" "github_actions_artifactregistry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_artifactregistry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "kubernetes_service_account_v1" "fraud_ksa" {
  metadata {
    name      = "fraud-ksa"
    namespace = "fraud"

    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.fraud_sa.email
    }
  }
}

resource "google_service_account_iam_binding" "binding" {
  service_account_id = google_service_account.fraud_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[fraud/fraud-ksa]"
  ]

  depends_on = [
    google_container_cluster.gke
  ]
}

output "github_actions_sa_email" {
  description = "Service account email for GitHub Actions"
  value       = google_service_account.github_actions.email
}
