provider "google" {
  region = var.gcp_region_name
}

provider "github" {
  owner = var.github_owner_name
  token = var.github_repository_pat
}

# BOOTSTRAP
# https://github.com/terraform-google-modules/terraform-google-bootstrap
module "bootstrap" {
  source  = "terraform-google-modules/bootstrap/google"
  version = "~> 6.4"

  org_id                  = var.gcp_organisation_id
  billing_account         = var.gcp_billing_account_id
  group_org_admins        = var.gcp_group_org_admins
  group_billing_admins    = var.gcp_group_billing_admins
  default_region          = var.gcp_region_name
  project_prefix          = "iac"
  tf_service_account_id   = "iac-service-account"
  tf_service_account_name = "Organisation IaC Service Account"
}

# SERVICE ACCOUNT KEY
resource "google_service_account_key" "iac" {
  service_account_id = module.bootstrap.terraform_sa_name
}

# PROJECT CREATOR ROLE
resource "google_organization_iam_member" "project_creator" {
  org_id = var.gcp_organisation_id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${module.bootstrap.terraform_sa_email}"
}