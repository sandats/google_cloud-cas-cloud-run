resource "google_service_account" "ocsp_gen_a" {
  display_name = "ocsp-gen-a"
  account_id   = "ocsp-gen-a"
  description  = "Cloud Run OCSP Generator用"
}

resource "google_service_account" "ocsp_res_a" {
  display_name = "ocsp-res-a"
  account_id   = "ocsp-res-a"
  description  = "Cloud Run OCSP Responder用"
}

data "google_iam_policy" "ocsp_gen_a" {
  binding {
    role = google_project_iam_custom_role.ocsp_gen.id
    members = [
      "serviceAccount:${google_service_account.ocsp_gen_a.email}",
    ]
  }
}

resource "google_privateca_ca_pool_iam_policy" "ocsp_gen_a_to_test_ca_pool_c" {
  ca_pool     = "projects/${var.project}/locations/asia-northeast1/caPools/test-ca-pool-c"
  policy_data = data.google_iam_policy.ocsp_gen_a.policy_data
}