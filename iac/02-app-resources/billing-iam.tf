# BILLING BUDGET RESOURCE MANAGER SERVICE ACCOUNT
resource "google_service_account" "billing_budget_resource_manager" {
  account_id   = "sa-billing-budget-res-mgr"
  project      = google_project.billing.project_id
  display_name = "Billing Budget Resource Manager Service Account"
}

# BILLING BUDGET RESOURCE MANAGER SERVICE ACCOUNT IAM
resource "google_service_account_iam_member" "iac_sa_user" {
  service_account_id = google_service_account.billing_budget_resource_manager.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.gcp_iac_service_account_email}"
}

resource "google_project_iam_member" "cloud_function_sa_run_admin" {
  project = google_project.web.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.billing_budget_resource_manager.email}"
}

# DEPLOY SERVICE ACCOUNT IAM
resource "google_project_iam_member" "sa_deploy_billing_artifact_registry_repo_admin" {
  project = google_project.billing.project_id
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}
