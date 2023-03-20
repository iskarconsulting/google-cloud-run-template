locals {
  environment_labels_development = toset([
    "dev",
    "development"
  ])
  environment_labels_testing = toset([
    "tst",
    "test",
    "testing"
  ])
  environment_labels_production = toset([
    "prd",
    "prod",
    "production"
  ])
  is_dev_or_test_environment = contains(setunion(local.environment_labels_development, local.environment_labels_testing), var.environment)
}
