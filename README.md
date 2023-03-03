# Google Cloud Artifact Registry Repository & Cloud Run Template

A template repository to provision a website / API using GitHub Codespaces, GitHub Actions, Terraform, Docker, Google Cloud Artifact Registry and Google Cloud Run.

## Introduction

This template consists of three steps:

1. Initial provisioning (one time manual process) of the Infrastructure as Code (IaC) Seed resources - using the [Google / Terraform Bootstrap module](https://github.com/terraform-google-modules/terraform-google-bootstrap).
1. Provisioning (repeatable GitHub Action) of the Google Cloud projects, Artifact Registry Repository and Cloud Run resources.
1. Build, Push and Deployment (repeatable GitHub Action) of the web source code.

## Prerequisites

- A Google Cloud Account with:
  - billing activated.
  - the Organisation Admins group (e.g. `gcp-organisation-admins@<YOUR.DOMAIN>`) defined and populated.
  - the Billing Admins group (e.g. `gcp-billing-admins@<YOUR.DOMAIN>`) defined and populated.
- A GitHub account.

## Project Directories Overview

### `/.devcontainer`

Contains resources (Google Cloud SDK and Terraform) for the GitHub Workspace for this project.

  - `devcontainer.json` (workspace settings)
  - `Dockerfile` (workspace build definition)

### `/.github/workflows`

Contains the YAML workflow definitions for the GitHub Actions.

### `/iac`

Contains the Terraform files and script files for provisioning the resources (projects, service accounts, IAM permissons, Artifact Registry and Cloud Run) in Google Cloud Platform.

### `/src`

Contains the application code and Dockerfile for the website / API.

## Setup

### Step 0 - Fork this Repository

Fork this repository so that you can run GitHub Codespaces in your GitHub Organisation.

### Step 1 - Configuring the IaC Seed Resources

This step will provision the IaC Seed resources (project and service account). The IaC service account is used to provision all subsequent resources.

1. Create a GitHub Personal Access Token (PAT)
    
    Login to your GitHub account and create a new fine grained PAT (Settings > Developer Settings > Personal Access Tokens > Fine Grained Tokens) with the permissions `Actions: Read and write`, `Metadata: Read-only`, `Secrets Read and write` and `Variables: Read and write`.

    Copy the generated PAT (this will be pasted into the `tfvars` file subsequently).
    
    The PAT will be stored as a GitHub repository secret `GH_REPOSITORY_PAT` for use by subsequent steps.

    PATs expire after a predetermined period. Manually rotate the PAT and update the repository secret `GH_REPOSITORY_PAT` with the new token value as necessary.

1. Start a GitHub Codespace for the Repository

    [GitHub Codespaces](https://github.com/features/codespaces) are virtual development environments hosted by GitHub. They are built from a Dockerfile (`/.devcontainer/Dockerfile` in the repository). All the prerequisites for building and deploying this first step are installed in the Codespace.

    To start the Codespace:
    
    - Click on the `<> Code v` button.
    - Click on the `Create a Codespace on Main` button.

    The first time the GitHub Codespace is run it will take 5+ minutes before you get a terminal prompt. This is because the Codespace will be built using the Dockerfile.

1. Change Directory using the Codespaces Terminal

    `cd iac/01-terraform-seed`

1. Configure the terraform.tfvars File
    
    Using the Codespace editor, open the file `/iac/01-terraform-seed/terraform.tfvars` and update the values for your environment.

1. Add a `secret.tfvars` File

    Using the Codespace editor, create a new file `/iac/01-terraform-seed/secret.tfvars`.

    Add the following keys and set the values to those that match your environment:

    ```BASH
    github_owner_name      = "" # "owner-name" from owner-name/repo-name
    github_repository_name = "" # "repo-name" from owner-name/repo-name
    github_repository_pat  = "" # "github_pat_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

    gcp_organisation_id      = "" # "012345678901"
    gcp_billing_account_id   = "" # "012345-678901-ABCDEF"
    gcp_group_org_admins     = "" # "org-admins-group@domain.com"
    gcp_group_billing_admins = "" # "billing-admins-group@domain.com"
    ```

    Do __NOT__ commit this file to the repository. There is an entry in the `.gitignore` file to ignore all `**/secret.tfvars` files.

    Store the generated Terraform state files (`terraform.tfstate` and `terraform.tfstate.backup`) securely as these will contain secrets in plain text. Do __NOT__ commit the state files to the repository.

1. Authenticate with Google Cloud

    https://cloud.google.com/docs/authentication/application-default-credentials

    Using the Codespace terminal, execute the following command.

    ```BASH
    gcloud auth application-default login
    ```

    The command will return a URL. Copy and paste this URL into a browser on your local machine. Follow the authentication workflow and copy the key that is generated.

    Return to the Codespace terminal and paste the key.

1. Initialise Terraform

    Execute the following command using the Codespace terminal.

    ```BASH
    terraform init
    ```

1. Generate a Terraform Plan

    Execute the following command using the Codespace terminal.

    ```BASH
    terraform plan -var-file="secret.tfvars"
    ```

1. Apply the Changes in the Terraform Plan

    Execute the following command using the Codespace terminal.

    ```BASH
    terraform apply -var-file="secret.tfvars"
    ```

1. Verification

    You can list the new resources with the [asset search-all-resources](https://cloud.google.com/sdk/gcloud/reference/asset/search-all-resources) command.

    Execute the following command using the Codespace terminal.

    ```BASH
    gcloud asset search-all-resources --project <Your New Project Id>
    ```

## Step 2 - Provisioning the Google Cloud Artifact Registry Repository, Service Account and Google Cloud Run Resources

This step will provision the Google Cloud resources necessary to host the website / API.

1. Return to your repository on the GitHub website and navigate to GitHub Actions.
1. Manually run the GitHub Actions Workflow `02-iac-provision-app-resources`.

The workflow is configured to execute automatically if any changes are pushed to the IAC code in the `/iac/02-app-resources` directory.

## Step 3 - Building and Deploying the Website / API Source Code

This step will build the website / API into a Docker container and push it to your Google Artifact Repository (created in the previous step). It will then configure Google Cloud Run to pull the container version and execute it.

1. Return to your repository on the GitHub website and navigate to GitHub Actions.
1. Manually run the GitHub Actions Workflow `03-build-deploy-app`.

The workflow is configured to execute automatically if any changes are pushed to the website / API source code in the `/src` directory.

## Verification

1. Get the CloudRun service URL:

    ```BASH
    gcloud run services list --project=<Your Web Project ID>
    ```

1. Paste this into a browser address bar (or use CURL). You should see the 'Hello World' response.

## Notes

### IAM

The file `\iac\02-app-resources\iam.tf` contains IAM definitions for the artifacts and web projects.

The given IAM admin definitions are only applied if the variable `environment` is configured to be one of the values defined by the variables `environment_labels_development` or `environment_labels_testing`.

Add any IAM definitions as necessary for least privilege for production environments.

## Optional Configuration

### Configure Domain Name(s) to Point to the Google Cloud Run Instance

The file `/iac/02-app-resources/web.tf` contains a block for assigning domain name(s) to the Cloud Run instance. Add the domain name(s) to the variable `domain_names` if this is required.

A prerequisite for this is to register the domain name(s) with your Google Cloud organisation.

The Cloud Run service issues and assigns a SSL certificate for each domain name.
