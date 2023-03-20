variable "organisation_abbreviation" {
  type = string
}

variable "environment" {
  type        = string
  description = "Label to describe the current environment: [dev|test|prod]."
  default     = "dev"
}

variable "dev_test_admin_members" {
  type = set(string)
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_repository" {
  type = string
}

variable "github_workspace" {
  type = string
}

variable "gcp_region_name" {
  type = string
}

variable "gcp_organisation_id" {
  type = string
}

variable "gcp_billing_account_id" {
  type = string
}

variable "gcp_iac_project_id" {
  type = string
}

variable "gcp_iac_state_bucket_id" {
  type = string
}

variable "gcp_iac_service_account_email" {
  type = string
}

variable "domain_names" {
  type        = set(string)
  description = "Set of domain names to assign to the Cloud Run service."
  default     = []
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}