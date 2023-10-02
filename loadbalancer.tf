# resource "google_compute_address" "lb_external_ip_address" {
#   name         = "external-ip-for-cloud-run"
#   address_type = "EXTERNAL"
# }

resource "google_compute_global_address" "external_serverless_vpc_access_lb_ip_a" {
  name = "external-serverless-vpc-access-lb-ip-a"
}

resource "google_compute_managed_ssl_certificate" "external_serverless_neg_certs" {
  name        = "external-serverless-neg-certs"
  description = "cloudrun-serverless-neg-*.test.${var.domain}"

  managed {
    domains = [
      "cloudrun-serverless-neg-a.test.${var.domain}",
      "cloudrun-serverless-neg-b.test.${var.domain}",
    ]
  }
}

resource "google_compute_backend_service" "external_serverless_bs_a" {
  name                            = "external-serverless-bs-a"
  connection_draining_timeout_sec = 0
  #  security_policy =   
  backend {
    group = google_compute_region_network_endpoint_group.test_neg_a.id
  }
}

resource "google_compute_backend_service" "external_serverless_bs_b" {
  name                            = "external-serverless-bs-b"
  connection_draining_timeout_sec = 0
  #  security_policy =   
  backend {
    group = google_compute_region_network_endpoint_group.test_neg_b.id
  }
}

resource "google_compute_url_map" "external_serverless_um_a" {
  name = "external-serverless-um-a"

  default_service = google_compute_backend_service.external_serverless_bs_a.id
}
