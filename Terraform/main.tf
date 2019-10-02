
provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "jenkins" {
 name         = "jenkins"
 machine_type = var.machine_type
 zone         = var.zone
 tags         = ["http-8080", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    ssh-keys = "Gin:${file(var.public_key_path)}"
  }

  metadata_startup_script = ""
  
  network_interface {
    network = var.network
    network_ip = var.network_ip
    access_config {
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "test-network"
}