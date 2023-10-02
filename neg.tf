resource "google_compute_region_network_endpoint_group" "test_neg_a" {
  name                  = "test-neg-a"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.test_cloud_run_svc_a.name
  }
}

resource "google_compute_region_network_endpoint_group" "test_neg_b" {
  name                  = "test-neg-b"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.test_cloud_run_svc_b.name
  }
}
