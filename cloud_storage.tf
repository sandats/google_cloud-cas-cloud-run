resource "google_storage_bucket" "ocsp_gen_bucket_a" {
  name          = "ocsp-gen-bucket-a"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = true
}

# note: オーナーアカウントでは設定不可、ストレージ管理者の権限が必要（？？？）
data "google_iam_policy" "ocsp_gen_bucket_a_storage_objectAdmin" {
  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:${google_service_account.ocsp_gen_a.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "ocsp_gen_bucket_a" {
  bucket      = google_storage_bucket.ocsp_gen_bucket_a.name
  policy_data = data.google_iam_policy.ocsp_gen_bucket_a_storage_objectAdmin.policy_data
}