resource "random_id" "web_project_id_random_suffix" {
  byte_length = 3
}

resource "random_id" "web_project_name_random_suffix" {
  byte_length = 3
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project
resource "google_project" "web" {
  name            = "Web ${title(var.environment)}"
  project_id      = "${var.organisation_abbreviation}-web-${var.environment}-${random_id.web_project_id_random_suffix.hex}"
  org_id          = var.gcp_organisation_id
  billing_account = var.gcp_billing_account_id
}

# CLOUD RUN
resource "google_cloud_run_service" "web" {
  name                       = "${var.organisation_abbreviation}-web-${var.environment}-${random_id.web_project_name_random_suffix.hex}"
  project                    = google_project.web.project_id
  location                   = var.gcp_region_name
  autogenerate_revision_name = true

  template {
    spec {
      containers {
        image = var.container_image
        ports {
          container_port = var.container_port
        }
        resources {
          limits = {
            "memory" = "256Mi"
            "cpu"    = "1000m"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
        "run.googleapis.com/client-name"   = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "10m"
  }

  depends_on = [
    google_project_service.web_apis
    #google_project_iam_binding.service_account_compute_artifact_registry_read
  ]
}
