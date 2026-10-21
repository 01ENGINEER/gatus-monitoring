# Terraform Remote State Backend

This project uses Amazon S3 to store Terraform state remotely.

## Purpose

The S3 backend allows Terraform to manage infrastructure
consistently from local development and GitHub Actions.

## Backend configuration

- AWS Region: eu-west-2
- State key: gatus-monitoring/dev/terraform.tfstate
- Encryption: Enabled
- Locking: S3 native lockfile
- Public access: Blocked at bucket level
- Versioning: Enabled at bucket level

## Bootstrap requirement

The S3 bucket must exist before running Terraform init
with the remote backend.

The bucket must be created separately from the main
Terraform infrastructure.

## Initialize the backend

After creating the S3 bucket:

terraform -chdir=infra init \
  -backend-config="bucket=YOUR_UNIQUE_BUCKET_NAME"

## Important

Do not commit Terraform state files or AWS credentials
to GitHub.

The GitHub Actions Terraform deployment role will need
permissions to access the S3 state object and lockfile.
