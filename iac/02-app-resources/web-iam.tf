# LOCALS
locals {
  web_project_service_account_deploy_roles = toset([
    "roles/run.developer",
    "roles/iam.serviceAccountUser"
  ])
}

# SERVICE ACCOUNT
# Service account to deploy web docker container to the Artifact Registry Repository.
resource "google_service_account" "deploy" {
  project      = google_project.web.project_id
  account_id   = "web-deploy"
  display_name = "Web deployment service account."
}

resource "google_service_account_key" "deploy" {
  service_account_id = google_service_account.deploy.id
}

# CLOUD RUN - NOAUTH - Allow unauthenticated users to invoke the service.
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.web.location
  project  = google_cloud_run_service.web.project
  service  = google_cloud_run_service.web.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# CLOUD RUN - ADMIN
resource "google_project_iam_member" "org_admins_cloud_run_admin" {

  # Optional IAM for Development and Test Environments
  for_each = local.is_dev_or_test_environment ? var.dev_test_admin_members : [] # NOT enabled in production.

  project = google_project.web.project_id
  role    = "roles/run.admin"
  member  = each.value
}

# ERROR REPORTING - ADMIN
resource "google_project_iam_member" "org_admins_errorreporting_admin" {

  # Optional IAM for Development and Test Environments
  for_each = local.is_dev_or_test_environment ? var.dev_test_admin_members : [] # NOT enabled in production.

  project = google_project.web.project_id
  role    = "roles/errorreporting.admin"
  member  = each.value
}

# SERVICE ACCOUNT - DEPLOY ROLES
resource "google_project_iam_member" "web_service_account_deploy_roles" {
  for_each = local.web_project_service_account_deploy_roles

  project = google_project.web.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.deploy.email}"
}
