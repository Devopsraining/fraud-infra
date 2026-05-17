resource "google_container_cluster" "gke" {
  name                = "fraud-cluster"
  location            = "us-central1-a"

  depends_on = [
    google_project_service.required_apis
  ]

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = false
    enable_private_endpoint = false
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_pubsub_topic" "fraud_topic" {
  name = "fraud-topic"
}

resource "google_pubsub_subscription" "fraud_sub" {
  name  = "fraud-sub"
  topic = google_pubsub_topic.fraud_topic.name
}

resource "google_container_node_pool" "nodes" {
  name     = "node-pool"
  cluster  = google_container_cluster.gke.name
  location = "us-central1-a"

  node_count = 3

  node_config {
    machine_type = "e2-standard-4"

    disk_size_gb = 50
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}