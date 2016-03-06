
resource "google_compute_instance" "openvpn_server" {
    name = "openvpn-server"
    machine_type = "${var.machine_type}" 
    zone = "us-central1-a"
    tags = ["openvpn-server"]

    disk {
        image = "${var.image}"
    }

    can_ip_forward = true

    network_interface {
        network = "default"
        access_config {
            // Ephemeral IP
            // nat_ip = <vpn_static_adddress_ip>
        }
    }

    metadata {
        "user-data" = "${file("artifacts/vpn_cloud_config.yaml")}"
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}

output "vpn_service_ip" {
    value = "${google_compute_instance.openvpn_server.assigned_nat_ip}"
}

resource "google_compute_firewall" "allow-vpn" {
    name = "allow-openvpn"
    description = "Allow openvpn from anywhere."
    network = "default"

    allow {
        protocol = "udp"
        ports = ["1194"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["openvpn-server"]
}