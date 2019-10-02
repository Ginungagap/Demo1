resource "google_compute_firewall" "http-8080" {
  name    = "http-8080"
  network = var.network

  target_tags = ["http-8080"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}