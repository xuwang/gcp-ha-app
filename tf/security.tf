# Firewalls for www
resource "google_compute_firewall" "www-allow-service" {
    name = "allow-www"
    description = "Allow www from anywhere."
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["www-server"]
}
