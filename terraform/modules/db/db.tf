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
    # No external IP for internal-only DB traffic
  }

  tags = var.network_tags

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      INIT_MARKER="/var/lib/mongodb/.initialized"
      if [ ! -f "$INIT_MARKER" ]; then
        apt-get update
        apt-get install -y gnupg curl
        wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
        echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
        apt-get update
        apt-get install -y mongodb-org=6.0.9 mongodb-org-server=6.0.9 mongodb-org-shell=6.0.9 mongodb-org-mongos=6.0.9 mongodb-org-tools=6.0.9
        systemctl enable mongod
        systemctl start mongod
        touch "$INIT_MARKER"
      fi
    EOT
  }
}
