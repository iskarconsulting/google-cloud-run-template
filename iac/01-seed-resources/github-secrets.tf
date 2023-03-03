# GITHUB SECRETS
# Service Account Credentials
resource "github_actions_secret" "iac_service_account_credentials" {
  repository      = var.github_repository_name
  secret_name     = "GCP_SERVICE_ACCOUNT_IAC_CREDENTIALS"
  plaintext_value = base64decode(google_service_account_key.iac.private_key)
}

resource "github_actions_secret" "github_repository_pat" {
  repository      = var.github_repository_name
  secret_name     = "GH_REPOSITORY_PAT"
  plaintext_value = var.github_repository_pat
}
