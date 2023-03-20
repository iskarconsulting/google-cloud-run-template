# ARTIFACTS - IAM
resource "google_project_iam_member" "org_admins_artifact_registry_admin" {

  # Optional IAM for Development and Test Environments
  for_each = local.is_dev_or_test_environment ? var.dev_test_admin_members : [] # NOT enabled in production.

  project = google_project.artifacts.project_id
  role    = "roles/artifactregistry.admin"
  member  = each.value
}

# SERVICE ACCOUNT - DEPLOY
resource "google_project_iam_member" "service_account_deploy_role_artifact_registry_repository_admin" {
  project = google_project.artifacts.project_id
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

# SERVICE ACCOUNT - COMPUTE
resource "google_project_iam_member" "service_account_compute_artifact_registry_read" {
  project = google_project.artifacts.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:service-${google_project.web.number}@serverless-robot-prod.iam.gserviceaccount.com"
}
