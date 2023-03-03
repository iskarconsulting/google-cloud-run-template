# GITHUB VARIABLES
# Artifacts Project Id
resource "null_resource" "github_action_variables_artifacts_project_id" {
  triggers = {
    artifacts_project_id = google_project.artifacts.project_id
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_token
      OWNER    = split("/", var.github_repository)[0],
      REPO     = split("/", var.github_repository)[1],
      VARNAME  = "GCP_ARTIFACTS_PROJECT_ID",
      VARVALUE = google_project.artifacts.project_id
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}


# Artifacts Repository Id
resource "null_resource" "github_action_variables_artifacts_repository_id" {
  triggers = {
    artifacts_repository_id = google_artifact_registry_repository.default.repository_id
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_token
      OWNER    = split("/", var.github_repository)[0],
      REPO     = split("/", var.github_repository)[1],
      VARNAME  = "GCP_ARTIFACTS_REPOSITORY_ID",
      VARVALUE = google_artifact_registry_repository.default.repository_id
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}
