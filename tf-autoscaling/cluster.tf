# Autoscaling Groups of Instances
# See https://cloud.google.com/compute/docs/autoscaler

resource "google_compute_instance_template" "demo-tempalte" {
    name = "demo-tempalte"
    description = "www server instance template"
    instance_description = "www server"
    machine_type = "${var.machine_type}" 
    can_ip_forward = false
    tags = ["www-server"]

    disk {
        source_image = "${var.image}"
        auto_delete = true
        boot = true
        mode = "READ_WRITE"
        type = "PERSISTENT"
    }

    network_interface {
        network = "default"
        access_config {
            //// Ephemeral IP
        }
    }

    metadata {
        "user-data" = "${file("${var.cloud_config_file}")}"
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }

    scheduling {
        automatic_restart = true
        on_host_maintenance = "MIGRATE"
    }
}
