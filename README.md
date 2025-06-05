# pluto-terraform

Terraform IaC for Moonbank PLUTO project automation in GCP.

This creates:
- GCS bucket
- BigQuery dataset and table
- Pub/Sub topic and subscription
- Cloud Function (in next step)
- Cloud Asset Inventory feed

## Usage

```bash
terraform init
terraform plan
terraform apply
