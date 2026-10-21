terraform {
  backend "s3" {
    key          = "gatus-monitoring/dev/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
