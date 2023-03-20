# LOCALS
locals {
  billing_project_apis = toset([
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "eventarc.googleapis.com",
    "run.googleapis.com"
  ])
}

# APIs
resource "google_project_service" "billing_apis" {
  for_each = local.billing_project_apis

  project = google_project.billing.project_id
  service = each.value
}
