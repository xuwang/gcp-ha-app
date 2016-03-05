# Firewalls for www
resource "google_compute_firewall" "allow-demo" {
    name = "allow-demo"
    description = "Allow www from anywhere."
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["www-server"]
}
