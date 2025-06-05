resource "google_storage_bucket" "pluto_bucket" {
  name                        = var.bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "pluto_dataset" {
  dataset_id = "activities"
  location   = var.region
}

resource "google_bigquery_table" "pluto_table" {
  dataset_id = google_bigquery_dataset.pluto_dataset.dataset_id
  table_id   = "resources"

  schema = jsonencode([
    {
      name = "messages"
      type = "STRING"
      mode = "NULLABLE"
    }
  ])
}

resource "google_pubsub_topic" "pluto_topic" {
  name = "activities"
}

resource "google_pubsub_subscription" "pluto_subscription" {
  name  = "activities-catchall"
  topic = google_pubsub_topic.pluto_topic.name
}
