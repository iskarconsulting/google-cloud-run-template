variable "github_owner_name" {
  type = string
  sensitive = true
}

variable "github_repository_name" {
  type = string
  sensitive = true
}

variable "github_repository_pat" {
  type      = string
  sensitive = true
}

variable "gcp_region_name" {
  type = string
}

variable "gcp_organisation_id" {
  type = string
  sensitive = true
}

variable "gcp_group_org_admins" {
  type = string
  sensitive = true
}

variable "gcp_group_billing_admins" {
  type = string
  sensitive = true
}

variable "gcp_billing_account_id" {
  type = string
  sensitive = true
}

variable "web_container_image_name" {
  type = string
}

variable "web_container_image" {
  type = string
}

variable "web_container_port" {
  type = number
}