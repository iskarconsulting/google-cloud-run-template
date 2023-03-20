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
  activate_apis = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudfunctions.googleapis.com",
    "eventarc.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
  sa_org_iam_permissions = [
    "roles/billing.costsManager",
    "roles/cloudfunctions.admin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.projectCreator",
    "roles/storage.admin"
  ]
}

# SERVICE ACCOUNT KEY
resource "google_service_account_key" "iac" {
  service_account_id = module.bootstrap.terraform_sa_name
}

# COMPUTE SERVICE ACCOUNT
data "google_compute_default_service_account" "iac_project" {
  project = module.bootstrap.seed_project_id
}

resource "google_service_account_iam_member" "iac-seed-compute-sa" {
  service_account_id = data.google_compute_default_service_account.iac_project.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${module.bootstrap.terraform_sa_email}"
}