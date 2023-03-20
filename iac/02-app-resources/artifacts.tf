resource "random_id" "artifacts_project_id_random_suffix" {
  byte_length = 3
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project
resource "google_project" "artifacts" {
  name            = "Artifacts ${title(var.environment)}"
  project_id      = "${var.organisation_abbreviation}-artifacts-${var.environment}-${random_id.artifacts_project_id_random_suffix.hex}"
  org_id          = var.gcp_organisation_id
  billing_account = var.gcp_billing_account_id
}

# ARTIFACT REGISTRY REPOSITORY
resource "google_artifact_registry_repository" "default" {
  location      = var.gcp_region_name
  project       = google_project.artifacts.project_id
  repository_id = "${var.organisation_abbreviation}-web"
  description   = "Docker Repository for Web Containers"
  format        = "DOCKER"
  depends_on = [
    google_project_service.artifacts_apis
  ]
}
