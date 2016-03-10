resource "google_storage_bucket" "ha_demo" {
    name = "ha-demo-bucket"
    location = "US"
}

resource "google_storage_bucket_object" "image1" {
    name = "app-image"
    depends_on = ["null_resource.etcd_discovery_url"]

    bucket = "${google_storage_bucket.ha_demo.name}"
    source = "artifacts/cloud.jpg"
}

# Get a public availabe google cloud image
resource "null_resource" "etcd_discovery_url" {
    provisioner "local-exec" {
        command = "curl -s https://placester.com/wp-content/uploads/2012/04/cloud.jpg > artifacts/cloud.jpg"
    }
}