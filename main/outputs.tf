output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}