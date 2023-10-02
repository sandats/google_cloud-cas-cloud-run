resource "google_artifact_registry_repository" "ca_service_ocsp" {
  location      = var.region
  repository_id = "ca-service-ocsp"
  description   = "CA Service OCSP container images"
  format        = "DOCKER"
}