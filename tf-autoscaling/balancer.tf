
# See https://cloud.google.com/compute/docs/load-balancing/http/

# www service ip
resource "google_compute_global_address" "demo-address" {
    name = "demo-address"
}

output "www_service_ip" {
    value = "${google_compute_global_address.demo-address.address}"
}

resource "google_compute_global_forwarding_rule" "demo-forwarding" {
    name = "demo-forwarding"
    description = "bind the www service ip ip to target pool"
    target = "${google_compute_target_http_proxy.demo-proxy.self_link}"
    ip_address = "${google_compute_global_address.demo-address.address}"
    ip_protocol = "TCP"
    port_range = "80"
}

resource "google_compute_target_http_proxy" "demo-proxy" {
    name = "demo-proxy"
    description = "a description"
    url_map = "${google_compute_url_map.demo-url-map.self_link}"
}

resource "google_compute_url_map" "demo-url-map" {
    name = "demo-url-map"
    description = "map ha-demo url to ha-demo backend"
    default_service = "${google_compute_backend_service.demo-backend.self_link}"

    host_rule {
        hosts = ["${google_compute_global_address.demo-address.address}"]
        path_matcher = "demo-path-matcher"
    }
    path_matcher {
        default_service = "${google_compute_backend_service.demo-backend.self_link}"
        name = "demo-path-matcher"
        path_rule {
            paths = ["/*"]
            service = "${google_compute_backend_service.demo-backend.self_link}"
        }
    }
}

resource "google_compute_backend_service" "demo-backend" {
    name = "demo-backend"
    description = "HA nodejs app demo"
    port_name = "http"
    protocol = "HTTP"
    timeout_sec = 10
    region = "us-central1"

    backend {
        group = "${google_compute_instance_group_manager.demo-manager.instance_group}"
    }

    health_checks = ["${google_compute_http_health_check.demo-check.self_link}"]
}

resource "google_compute_http_health_check" "demo-check" {
    name = "demo-check"
    port = "80"
    request_path = "/"
    check_interval_sec = 5
    timeout_sec = 5
}


# www server pool
resource "google_compute_target_pool" "demo-pool" {
    name = "demo-pool"
    description = "www server pool"
}

resource "google_compute_instance_group_manager" "demo-manager" {
    description = "HiDemo instance group manager"
    name = "demo-manager"
    instance_template = "${google_compute_instance_template.demo-tempalte.self_link}"
    update_strategy= "NONE"
    target_pools = ["${google_compute_target_pool.demo-pool.self_link}"]
    base_instance_name = "www"
    zone = "us-central1-a"

    named_port {
        name = "http"
        port = 80
    }
}

resource "google_compute_autoscaler" "demo-autoscaler" {
    name = "demo-autoscaler"
    zone = "us-central1-a"
    target = "${google_compute_instance_group_manager.demo-manager.self_link}"
    autoscaling_policy = {
        max_replicas = "${var.max_replicas}"
        min_replicas = "${var.min_replicas}"
        cooldown_period = 60
        cpu_utilization = {
            target = "${var.cpu_utilization}"
        }
    }
}

