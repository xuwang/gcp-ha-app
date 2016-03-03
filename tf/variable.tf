
# Use your own PROJECT ID
variable "google_project_id" { 
    default = "ha-demo-20160303"
}

variable "account_file" {
    default = "account.json"
}

variable "region" {
    default = "us-central1"
}

variable "zones" {
    default = {
        zone0 = "us-central1-a"
        zone1 = "us-central1-b"
        zone2 = "us-central1-c"
        zone3 = "us-central1-f"
        zone4 = "us-central1-a"
        zone5 = "us-central1-b"
        zone6 = "us-central1-c"
        zone7 = "us-central1-f"
        zone8 = "us-central1-a"
        zone9 = "us-central1-b"
    }
}

variable "cluster_name" {
    default = "ha-demo"
}

variable "cloud_config_file" {
    default = "artifacts/cloud_config.yaml"
}

variable "discovery_url_file" {
    default = "artifacts/discovery_url.txt"
}

# gcloud compute images list | grep coreos-stable | awk '{print $1;}'
variable "image" {
    default = "coreos-stable-835-9-0-v20151208"
}

variable "machine_type" {
    default = "n1-standard-1"
}

variable "node_count" {
    default = 3
}