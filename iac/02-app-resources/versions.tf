terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.48.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.3"
    }
  }
  backend "gcs" {}
  required_version = "1.3.9"
}
