data "archive_file" "hello_world_nodejs_zip" {
  type        = "zip"
  source_dir  = "${path.module}/hello_world_nodejs/"
  output_path = "${path.module}/hello_world_nodejs.zip"
}

resource "google_storage_bucket_object" "hello_world_nodejs_zip" {
  name   = "hello_world_nodejs.zip"
  bucket = google_storage_bucket.hello_world_bucket.name
  source = "${path.module}/hello_world_nodejs.zip"
}

resource "google_cloudfunctions_function" "hello_world_nodejs_function" {
  project               = google_project.project.project_id
  name                  = "hello-world-nodejs-function"
  description           = "Hello World NodeJS Function"
  available_memory_mb   = 128
  max_instances         = 2
  source_archive_bucket = google_storage_bucket.hello_world_bucket.name
  source_archive_object = google_storage_bucket_object.hello_world_nodejs_zip.name
  timeout               = 60
  entry_point           = "helloGET"
  trigger_http          = true
  runtime               = "nodejs10"

  depends_on = [ google_project_service.service["cloudfunctions.googleapis.com" ] ]

}
