resource "google_storage_bucket" "hello_world_bucket" {
  name      = "hello_world_bucket_2"
  project   = google_project.project.project_id
  location  = var.region
}
