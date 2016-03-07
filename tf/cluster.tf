resource "google_compute_instance" "www" {
    count = "${var.node_count}"
    name = "www-${count.index+1}"
    machine_type = "${var.machine_type}" 
    # servers in a same zones
    #zone = "us-central1-b"
    # servers in different zones
    zone = "${lookup(var.zones, concat("zone", count.index))}"
    tags = ["www-server"]
    depends_on = ["google_compute_disk.docker"]

    disk {
        image = "${var.image}"
    }

    // External disk
    disk {
        device_name = "docker"
        disk = "docker-${count.index+1}"
        auto_delete = false
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

resource "google_compute_disk" "docker" {
    count = "${var.node_count}"
    name = "docker-${count.index+1}"
    type = "pd-ssd"
    zone = "${lookup(var.zones, concat("zone", count.index))}"
    size = 50
}


