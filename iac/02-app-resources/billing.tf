resource "random_id" "billing_project_id_random_suffix" {
  byte_length = 3
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project
resource "google_project" "billing" {
  name            = "Billing ${title(var.environment)}"
  project_id      = "${var.organisation_abbreviation}-billing-${var.environment}-${random_id.billing_project_id_random_suffix.hex}"
  org_id          = var.gcp_organisation_id
  billing_account = data.google_billing_account.account.billing_account
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.billing_account
  display_name    = "Billing Budget"
  amount {
    specified_amount {
      currency_code = "GBP"
      units         = "2"
    }
  }
  threshold_rules {
    threshold_percent = 1.0
  }
  all_updates_rule {
    pubsub_topic = google_pubsub_topic.billing_alerts.id
  }

}

resource "google_pubsub_topic" "billing_alerts" {
  name                       = "billing-alerts"
  project                    = google_project.billing.project_id
  message_retention_duration = "86600s"
}

resource "random_id" "billing_budget_bucket_suffix" {
  byte_length = 3
}

resource "google_storage_bucket" "billing_bucket" {
  name                        = "billing-budget-bucket-${random_id.billing_budget_bucket_suffix.hex}"
  location                    = var.gcp_region_name
  project                     = google_project.billing.project_id
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "function_source" {
  name   = "billing-budget-resource-manager-function-source.zip"
  bucket = google_storage_bucket.billing_bucket.name
  source = "${var.github_workspace}/iac/02-app-resources/billing-budget-resource-manager-function/function-source.zip"
}

resource "google_cloudfunctions2_function" "function" {
  name        = "billing-budget-resource-manager-function"
  location    = var.gcp_region_name
  project     = google_project.billing.project_id
  description = "Billing Budget Resource Manager Function"

  build_config {
    runtime     = "nodejs16"
    entry_point = "limitUse"
    source {
      storage_source {
        bucket = google_storage_bucket.billing_bucket.name
        object = google_storage_bucket_object.function_source.name
      }
    }
  }

  service_config {
    max_instance_count               = 1
    min_instance_count               = 0
    available_memory                 = "128Mi"
    timeout_seconds                  = 60
    max_instance_request_concurrency = 1
    environment_variables = {
      GCP_PROJECT_ID  = google_project.web.project_id
      GCP_REGION      = var.gcp_region_name
      GCP_CLOUDRUN_ID = google_cloud_run_service.web.name
    }
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.billing_budget_resource_manager.email
  }

  event_trigger {
    trigger_region = var.gcp_region_name
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.billing_alerts.id
    retry_policy   = "RETRY_POLICY_RETRY"
  }

  depends_on = [
    google_project_service.web_apis
  ]

  # Forces the function to rebuild / redeploy when the source changes.
  lifecycle {
    replace_triggered_by = [
      google_storage_bucket_object.function_source
    ]
  }
}
