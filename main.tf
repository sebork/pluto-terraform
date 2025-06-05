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

resource "google_storage_bucket_object" "pluto_function_source" {
  name   = "pluto-function.zip"
  bucket = var.bucket_name
  source = "${path.module}/cloudfunction/pluto-function.zip"

  depends_on = [google_storage_bucket.pluto_bucket] // Ensure bucket is created first
}

resource "google_cloudfunctions_function" "pluto_function" {
  name        = "pluto-function"
  description = "PLUTO function for capturing asset events"
  runtime     = "python39"
  region      = var.region
  source_archive_bucket = var.bucket_name
  source_archive_object = google_storage_bucket_object.pluto_function_source.name
  entry_point = "pubsub_to_bigquery"
  available_memory_mb = 256

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.pluto_topic.name
  }
}

