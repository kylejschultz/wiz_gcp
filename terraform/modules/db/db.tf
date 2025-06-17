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
    ssh-keys = "ubuntu:${var.ssh_public_key_path}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface[0].access_config[0].nat_ip
    private_key = var.ssh_private_key_path
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y gnupg curl",
      "curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor",
      "echo 'deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org=6.0.24 mongodb-org-database=6.0.24 mongodb-org-server=6.0.24 mongodb-mongosh mongodb-org-shell=6.0.24 mongodb-org-mongos=6.0.24 mongodb-org-tools=6.0.24 mongodb-org-database-tools-extra=6.0.24",
      "sudo systemctl enable mongod",
      "sudo systemctl start mongod"
    ]
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
