provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tf_state" {
  name     = "fraud-tf-state-${var.project_id}"
  location = var.region

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}