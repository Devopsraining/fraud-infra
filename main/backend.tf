terraform {
  backend "gcs" {
    bucket  = "fraud-tf-state-devops-492107"
    prefix  = "gke"
  }
}