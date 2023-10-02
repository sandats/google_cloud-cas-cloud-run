# require_auth: 認証が必要
resource "google_cloud_run_service" "cloud_run_svc_ocsp_server_a" {
  name     = "cloud-run-svc-ocsp-server-a"
  location = "asia-northeast1"

  template {
    spec {
      containers {
        image = "asia-northeast1-docker.pkg.dev/${var.project}/ca-service-ocsp/ocsp-generator:1.0"

        args = [
          "--projectID=${var.project}",
          "--location=${var.region}",
          "--useSecrets",
          "--ca_name=test-root-ca-c",
          "--pool=test-ca-pool-c",
          "--ocsp_signer_key=ocsp_signer_key",
          "--ocsp_signer_crt=ocsp_signer_crt",
          "--bucketName=ocsp-gen-bucket-a",
          "--expiry=3600s",
          "--http_port=:8080",
        ]
      }

      service_account_name = google_service_account.ocsp_gen_a.email
    }
  }


  # コンフリクト防止のためリビジョン名をCloud Run側で管理
  # https://github.com/hashicorp/terraform-provider-google/issues/5898
  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Cloud Runで自動更新される値を無視
  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/sandbox"],
      metadata[0].annotations["client.knative.dev/user-image"],
      metadata[0].annotations["run.googleapis.com/client-name"],
      metadata[0].annotations["run.googleapis.com/client-version"]
    ]
  }
}
