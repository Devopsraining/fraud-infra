resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudbuild.googleapis.com",          # Cloud Build
    "cloudkms.googleapis.com",            # Cloud KMS
    "container.googleapis.com",          # GKE
    "compute.googleapis.com",            # Networking / LB
    "iam.googleapis.com",                # IAM
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",                # Private DNS
    "storage.googleapis.com",             # GCS (tfstate)
    "artifactregistry.googleapis.com"     # Artifact Registry
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}