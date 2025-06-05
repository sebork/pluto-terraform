resource "google_service_account" "deployer" {
  account_id   = "gcp-deployment-automation"
  display_name = "Terraform Deployment Automation"
}
