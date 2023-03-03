provider "google" {
  project = var.gcp_iac_project_id
  region  = var.gcp_region_name
}

provider "github" {
  owner = split("/", var.github_repository)[0]
  token = var.github_token
}
