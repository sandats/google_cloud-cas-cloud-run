resource "google_project_service" "project_apis" {
  service = each.value
  for_each = toset([
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "storage-component.googleapis.com",
    "secretmanager.googleapis.com",
  ])

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true

  # Terraformリソースが破棄された時にAPIを無効化しない
  disable_on_destroy = false
}