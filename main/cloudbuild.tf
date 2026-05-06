resource "google_project_service" "cloudbuild" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_cloudbuild_trigger" "argocd_appsets" {
  name     = "ArgoCD-appsets"
  project  = var.project_id
  location = "us-central1"

  repository_event_config {
    repository = "projects/${var.project_id}/locations/us-central1/connections/fraud-argocd-conn/repositories/venkatesharelly-fraud-argocd"

    push {
      branch = "^main$"
    }
  }

  filename = "argo-appsets/cloudbuild.yaml"

  service_account = "projects/${var.project_id}/serviceAccounts/fraud-sa@${var.project_id}.iam.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild]
}

resource "google_cloudbuild_trigger" "argocd_projects" {
  name     = "ArgoCD-projects"
  project  = var.project_id
  location = "us-central1"

  repository_event_config {
    repository = "projects/${var.project_id}/locations/us-central1/connections/fraud-argocd-conn/repositories/venkatesharelly-fraud-argocd"

    push {
      branch = "^main$"
    }
  }

  filename = "argo-projects/cloudbuild.yaml"

  service_account = "projects/${var.project_id}/serviceAccounts/fraud-sa@${var.project_id}.iam.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild]
}