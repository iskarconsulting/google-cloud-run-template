organisation_abbreviation = "rmu"
# environment = dev|test|prod
environment = "dev"
# TODO Remove Sensitive Data.
dev_test_admin_members = [
  "group:gcp-organisation-admins@reducemyuse.org"
]

gcp_artifacts_project_name        = "Artifacts"
gcp_artifacts_project_name_suffix = "Production"
gcp_artifacts_project_apis = [
  "cloudresourcemanager.googleapis.com",
  "artifactregistry.googleapis.com"
]
gcp_artifacts_repository_name = "web"

gcp_web_project_name        = "Web"
gcp_web_project_name_suffix = "Production"
gcp_web_project_apis = [
  "cloudresourcemanager.googleapis.com",
  "run.googleapis.com"
]
gcp_web_project_service_account_deploy_roles = [
  "roles/run.developer",
  "roles/iam.serviceAccountUser"
]

# TODO Add any domain names to map to the Google Cloud Run service here:
domain_names = []
