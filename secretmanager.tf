resource "google_secret_manager_secret" "ocsp_signer_key" {
  secret_id = "ocsp_signer_key"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

data "google_iam_policy" "ocsp_signer_key" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:${google_service_account.ocsp_gen_a.email}",
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "ocsp_signer_key" {
  secret_id   = google_secret_manager_secret.ocsp_signer_key.secret_id
  policy_data = data.google_iam_policy.ocsp_signer_key.policy_data
}

resource "google_secret_manager_secret" "ocsp_signer_crt" {
  secret_id = "ocsp-signer-crt"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

data "google_iam_policy" "ocsp_signer_crt" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:${google_service_account.ocsp_gen_a.email}",
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "ocsp_signer_crt" {
  secret_id   = google_secret_manager_secret.ocsp_signer_crt.secret_id
  policy_data = data.google_iam_policy.ocsp_signer_crt.policy_data
}