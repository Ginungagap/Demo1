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

resource "null_resource" "jenkins_provisioner" {
 
  connection {
    type = "ssh"
    user = "Gin"
    host = "${google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip}"
    private_key = "${file(var.private_key_path)}"
    agent = false  
  } 

  provisioner "file" {
    source      = "scenario_jenkins.sh"
    destination = "~/scenario_jenkins.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/scenario_jenkins.sh",
      "sudo ~/scenario_jenkins.sh"
    ]
  }
}