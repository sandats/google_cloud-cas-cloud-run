resource "google_project_iam_custom_role" "ocsp_gen" {
  role_id     = "ocspGeneratorRole"
  title       = "OCSP Generator"
  description = "OCSP Generator 用カスタムロール"
  permissions = [
    "privateca.certificates.list",
    "privateca.certificates.get",
  ]
}