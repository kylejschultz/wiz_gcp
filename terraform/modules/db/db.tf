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
  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/devstorage.read_write"]
  }

  metadata = {
    startup-script = file("${path.module}/../../scripts/mongo-bootstrap.sh")
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

resource "google_compute_firewall" "db_mongo" {
  name    = "${var.instance_name}-mongo-ingress"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # only allow from your VPC subnet
  source_ranges = [
    var.subnet_cidr,
    var.pod_cidr
  ]

  # make sure your VM tags include this firewall
  target_tags = var.network_tags
}
