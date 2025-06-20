terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

resource "google_compute_instance" "db_vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-lts"
      size  = 50
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {}
  }

  tags = var.network_tags

  metadata = {
    startup-script = file("${path.module}/../../scripts/mongo-install.sh")
  }
}

resource "google_compute_firewall" "db_ssh" {
  name    = "${var.instance_name}-ssh-ingress"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.network_tags
}
