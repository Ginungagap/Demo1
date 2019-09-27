
provider "google" {
  credentials = file("project-for-terraform.json")
   project = "project-for-terraform"
  region  = "us-central1"
}

resource "google_compute_instance" "centos-jenkins" {
 name         = "centos-jenkins"
 machine_type = "f1-micro"
 zone         = "us-central1-a"
 tags         = ["test"]

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7-v20190905"
   }
 }

 metadata {
              "ssh-keys": "ilya_dog84:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCWrREUi+k0tugNUwcT9cj4K90pfjGTDEqqdH+GRueTZxxffFajrtBpQqC6gb42lc0aUXvQ7p5DfnVI7+FIbP7P6n4BC73iCWFlLkidjbHlFdstYFSZ/TUbKRt2OhSrIV5TtG/wQyrDDRDHvf20Qq30Jj8/XPmLB60RGjcOUkzsymXSNeIXBHrCeof/YjKYYFsVqlcq6oirh9L7Ak6bAuBt6dUsKVAtpm4vG3En/PrFzcHOWLjY7nl+YhGD+h9n/N1XPFjXH/N3EuK7oruHXhVl98fiQT/GTYM1PGBnQzo8M1rEmsjZbVPzD4AhbVfeR+tSpNhI9aSyeyIus5zHz2FV google-ssh {\"userName\":\"ilya.dog84@gmail.com\",\"expireOn\":\"2019-09-12T19:24:49+0000\"}\nGin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAGvFwuHdn/xcqyq4rkq2QzyAefJ9iSXF2BaV1alsdnmjpPrMeQOLozudWe97Qa4x8Pw6aXQqHtWfGZ46jSGE9hZvci2cdq8BqY8drtSDwVpqeKJ/b+Rpt7fA/BWmgqm6bgj760WU+2HrSZ3JhvzF8YT72Pq0QGDmIsY74/TCIBKQe/vEyB6Sq9EAJqKcLGNt0YXG5XdtcUkOnhQvjXhGCWMezPuFNbXV+5zIMhRprTASYfrj28ga1v3ub4GGXgyA76xyLQCNxt4J/ODgF+ZTztZFOdkw3ybyzGObTcU5h65Ba8cBE6vhvOrfSISVeoMMogpbO77/zPx/EbhrDZT6h Gin"
            },

// Make sure flask is installed on all new instances for later steps
 //metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

  tags = ["http-8080", "http-server", "https-server"]

}









// resource "google_compute_firewall" "default" {
//   name    = "test-firewall"
//   network = "${google_compute_network.default.name}"

//   allow {
//     protocol = "icmp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["80", "8080", "1000-2000"]
//   }

//   source_tags = ["web"]
// }

// resource "google_compute_network" "default" {
//   name = "test-network"
// }