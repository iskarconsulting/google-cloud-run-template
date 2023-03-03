locals {
  is_dev_or_test_environment = contains(setunion(var.environment_labels_development, var.environment_labels_testing), var.environment)
}
