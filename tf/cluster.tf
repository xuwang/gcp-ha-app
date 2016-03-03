resource "google_compute_instance" "www" {
    count = "${var.node_count}"
    name = "www-${count.index+1}"
    machine_type = "${var.machine_type}" 
    # servers in a same zones
    #zone = "us-central1-b"
    # servers in different zones
    zone = "${lookup(var.zones, concat("zone", count.index))}"
    tags = ["www-server"]

    disk {
        image = "${var.image}"
    }

    network_interface {
        network = "default"
        access_config {
            // Ephemeral IP
        }
    }

    metadata {
        "cluster-size" = "${var.node_count}"
        "user-data" = "${file("${var.cloud_config_file}")}"
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}


