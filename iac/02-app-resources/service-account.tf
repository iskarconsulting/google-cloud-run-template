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


# GITHUB SECRET
# Update deploy service account secret in the repository secrets.
resource "github_actions_secret" "deploy_service_account_credentials" {
  repository      = split("/", var.github_repository)[1]
  secret_name     = "GCP_SERVICE_ACCOUNT_DEPLOY_CREDENTIALS"
  plaintext_value = base64decode(google_service_account_key.deploy.private_key)
}
