# DOMAIN NAME MAPPINGS
# If Required, add domain name(s) to the `domain_names` set variable.
resource "google_cloud_run_domain_mapping" "main" {
  for_each = var.domain_names

  name     = each.value
  project  = google_cloud_run_service.web.project
  location = google_cloud_run_service.web.location
  metadata {
    namespace = google_project.web.project_id
  }
  spec {
    route_name = google_cloud_run_service.web.name
  }
}