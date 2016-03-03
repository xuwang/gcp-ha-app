# www service ip
resource "google_compute_address" "www" {
    name = "www-service"
}

output "www_service_ip" {
    value = "${google_compute_address.www.address}"
}

# www server pool
resource "google_compute_target_pool" "www" {
    name = "www-pool"
    description = "www server pool"
    # servers in a same zone
    #instances = [ "us-central1-b/www-1","us-central1-b/www-2","us-central1-b/www-3" ]
    # servers in different zones
    instances = ["${formatlist("%s/%s", google_compute_instance.www.*.zone, google_compute_instance.www.*.name)}"]

    # Not supported on google API: https://github.com/hashicorp/terraform/issues/4282
    # health_checks = [ "${google_compute_https_health_check.www.name}" ]
    health_checks = [ "${google_compute_http_health_check.www.name}" ]
}

# bind the web service ip to target pool
resource "google_compute_forwarding_rule" "www" {
    name = "www-app"
    description = "bind the www service ip ip to target pool"
    target = "${google_compute_target_pool.www.self_link}"
    ip_address = "${google_compute_address.www.address}"
    ip_protocol = "TCP"
    port_range = "80"
}

resource "google_compute_http_health_check" "www" {
    name = "www-check"
    port = "80"
    request_path = "/"
    check_interval_sec = 5
    timeout_sec = 5
}


