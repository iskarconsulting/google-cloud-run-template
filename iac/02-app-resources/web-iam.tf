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

  member = each.value
}

# ERROR REPORTING - ADMIN
resource "google_project_iam_member" "org_admins_errorreporting_admin" {

  # Optional IAM for Development and Test Environments
  for_each = local.is_dev_or_test_environment ? var.dev_test_admin_members : [] # NOT enabled in production.

  project = google_project.web.project_id
  role    = "roles/errorreporting.admin"

  member = each.value
}

# SERVICE ACCOUNT - DEPLOY ROLES
resource "google_project_iam_binding" "web_service_account_deploy_roles" {
  for_each = var.gcp_web_project_service_account_deploy_roles

  project = google_project.web.project_id
  role    = each.value
  members = [
    "serviceAccount:${google_service_account.deploy.email}",
  ]
}
