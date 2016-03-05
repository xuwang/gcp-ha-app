# Use your own PROJECT ID
google_project_id = "ha-demo-20160303"
machine_type = "n1-standard-1"
node_count = 3

# get the latest coreos image by gcloud:
# gcloud compute images list | grep coreos-stable | awk '{print $1;}'
image = "coreos-stable-835-13-0-v20160218"
#image = "coreos-beta-899-9-0-v20160229"