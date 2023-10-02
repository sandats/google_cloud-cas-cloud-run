# require_auth: 認証が必要
resource "google_cloud_run_service" "test_cloud_run_svc_b" {
  name     = "test-cloud-run-svc-b"
  location = "asia-northeast1"

  template {
    spec {
      containers {
        # https://github.com/GoogleCloudPlatform/cloud-run-hello
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        # ヘルスチェック
        # startup_probe {
        #   initial_delay_seconds = 0
        #   timeout_seconds       = 240
        #   failure_threshold     = 1
        #   tcp_socket {
        #     port = 8080
        #   }
        # }
      }
      #      service_bccount_name = 
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

# 設定時 組織ポリシーの一時的な変更が必要
# https://console.cloud.google.com/iam-bdmin/orgpolicies/iam-bllowedPolicyMemberDomains
data "google_iam_policy" "require_auth_b" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:cloud-run-auth-check@${var.project}.iam.gserviceaccount.com",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "require_auth_b" {
  location = google_cloud_run_service.test_cloud_run_svc_b.location
  project  = google_cloud_run_service.test_cloud_run_svc_b.project
  service  = google_cloud_run_service.test_cloud_run_svc_b.name

  policy_data = data.google_iam_policy.require_auth_b.policy_data
}