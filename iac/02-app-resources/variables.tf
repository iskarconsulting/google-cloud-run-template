variable "organisation_abbreviation" {
  type = string
}

variable "environment" {
  type        = string
  description = "Label to describe the current environment: [dev|test|prod]."
  default     = "development"
}

variable "environment_labels_development" {
  type        = set(string)
  description = "Set of posssible labels indicating development environment."
  default     = ["dev", "development"]
}

variable "environment_labels_testing" {
  type        = set(string)
  description = "Set of possible labels indicating a testing environment."
  default     = ["tst", "test", "testing"]
}

variable "environment_labels_production" {
  type        = set(string)
  description = "Set of possible labels indicating a production environment."
  default     = ["prd", "prod", "production"]
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

variable "gcp_artifacts_project_name" {
  type = string
}

variable "gcp_artifacts_project_name_suffix" {
  type = string
}

variable "gcp_artifacts_project_apis" {
  type = set(string)
}

variable "gcp_artifacts_repository_name" {
  type = string
}

variable "gcp_web_project_name" {
  type = string
}

variable "gcp_web_project_name_suffix" {
  type = string
}

variable "gcp_web_project_apis" {
  type = set(string)
}

variable "gcp_web_project_service_account_deploy_roles" {
  type = set(string)
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