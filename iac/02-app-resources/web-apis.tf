# LOCALS
locals {
  web_project_apis = toset([
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com"
  ])
}

# APIs
resource "google_project_service" "web_apis" {
  for_each = local.web_project_apis

  project = google_project.web.project_id
  service = each.value
}
