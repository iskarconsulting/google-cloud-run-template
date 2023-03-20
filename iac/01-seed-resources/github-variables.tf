# GITHUB VARIABLES
# GCP Region Name
resource "null_resource" "github_action_variables_gcp_region_name" {
  triggers = {
    gcp_region_name = var.gcp_region_name
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "GCP_REGION_NAME",
      VARVALUE = var.gcp_region_name
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}


# GCP Organisation Id
resource "null_resource" "github_action_variables_gcp_organisation_id" {
  triggers = {
    gcp_organisation_id = var.gcp_organisation_id
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "GCP_ORGANISATION_ID",
      VARVALUE = var.gcp_organisation_id
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# GCP Billing Account Id
resource "null_resource" "github_action_variables_gcp_billing_account_id" {
  triggers = {
    gcp_billing_account_id = var.gcp_billing_account_id
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "GCP_BILLING_ACCOUNT_ID",
      VARVALUE = var.gcp_billing_account_id
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# GCP IaC Project Id
resource "null_resource" "github_action_variables_gcp_seed_project_id" {
  triggers = {
    gcp_seed_project_id = module.bootstrap.seed_project_id
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "GCP_IAC_PROJECT_ID",
      VARVALUE = module.bootstrap.seed_project_id
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# GCP IaC Bucket Id
resource "null_resource" "github_action_variables_gcp_iac_state_bucket_id" {
  triggers = {
    gcp_iac_state_bucket_id = module.bootstrap.gcs_bucket_tfstate
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "GCP_IAC_STATE_BUCKET_ID",
      VARVALUE = module.bootstrap.gcs_bucket_tfstate
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# GCP IaC Seed Service Account EMail
resource "null_resource" "github_action_variables_gcp_iac_seed_sa_email" {
  triggers = {
    gcp_iac_seed_sa_email = module.bootstrap.terraform_sa_email
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "GCP_IAC_SERVICE_ACCOUNT_EMAIL",
      VARVALUE = module.bootstrap.terraform_sa_email
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# Web Container Image Name
resource "null_resource" "github_action_variables_web_container_image_name" {
  triggers = {
    web_container_image_name = var.web_container_image_name
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "WEB_CONTAINER_IMAGE_NAME",
      VARVALUE = var.web_container_image_name
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# Web Container Image
resource "null_resource" "github_action_variables_web_container_image" {
  triggers = {
    web_container_image = var.web_container_image
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "WEB_CONTAINER_IMAGE",
      VARVALUE = var.web_container_image
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}

# Web Container Port
resource "null_resource" "github_action_variables_web_container_port" {
  triggers = {
    web_container_port = var.web_container_port
  }

  provisioner "local-exec" {
    when = create
    environment = {
      GH_TOKEN = var.github_repository_pat
      OWNER    = var.github_owner_name,
      REPO     = var.github_repository_name,
      VARNAME  = "WEB_CONTAINER_PORT",
      VARVALUE = var.web_container_port
    }
    command     = "../99-scripts/set-repository-variable.ps1"
    interpreter = ["pwsh", "-File"]
  }
}