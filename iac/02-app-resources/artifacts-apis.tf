# LOCALS
locals {
  artifacts_project_apis = toset([
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
}

# APIs
resource "google_project_service" "artifacts_apis" {
  for_each = local.artifacts_project_apis

  project = google_project.artifacts.project_id
  service = each.value
}
