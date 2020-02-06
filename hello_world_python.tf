data "archive_file" "hello_world_python_zip" {
  type        = "zip"
  source_dir  = "${path.module}/hello_world_python/"
  output_path = "${path.module}/hello_world_python.zip"
}

resource "google_storage_bucket_object" "hello_world_python_zip" {
  name   = "hello_world_python.zip"
  bucket = google_storage_bucket.hello_world_bucket.name
  source = "${path.module}/hello_world_python.zip"
}

resource "google_cloudfunctions_function" "hello_world_python_function" {
  project               = google_project.project.project_id
  name                  = "hello-world-python-function"
  description           = "Scheduled Hello World Python Function"
  available_memory_mb   = 256
  max_instances         = 2
  source_archive_bucket = google_storage_bucket.hello_world_bucket.name
  source_archive_object = google_storage_bucket_object.hello_world_python_zip.name
  timeout               = 60
  entry_point           = "hello_world_python"
  trigger_http          = true
  runtime               = "python37"

  depends_on = [ google_project_service.service["cloudfunctions.googleapis.com" ] ]
}

resource "google_app_engine_application" "hello_world_python_scheduler_app" {
  project     = google_project.project.project_id
  location_id = var.region

  depends_on = [ google_project_service.service["cloudfunctions.googleapis.com" ] ]
}

resource "google_cloud_scheduler_job" "hello_world_python_trigger" {
  project     = google_project.project.project_id
  name        = "hello-world-scheduler-job"
  schedule    = var.schedule_cron
  time_zone   = "Europe/Berlin"

  http_target {
    uri = google_cloudfunctions_function.hello_world_python_function.https_trigger_url
  }

  depends_on = [ 
    google_app_engine_application.hello_world_python_scheduler_app,
    google_project_service.service["cloudscheduler.googleapis.com" ] 
    ]
}