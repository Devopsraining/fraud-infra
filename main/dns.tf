resource "google_dns_managed_zone" "private_zone" {
  name        = "fraud-private-zone"
  dns_name    = "internal."
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}

resource "google_dns_record_set" "ml" {
  name         = "ml.internal."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas      = ["10.30.0.10"] # replace later
}

resource "google_dns_record_set" "argocd" {
  name         = "argocd.internal."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas      = ["10.30.0.20"]
}

resource "google_dns_record_set" "sonar" {
  name         = "sonar.internal."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas      = ["10.30.0.30"]
}