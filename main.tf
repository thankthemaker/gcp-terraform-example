provider "google" {
 # credentials  = file("${var.credentialsfile}")
 # project      = var.project_id
  region        = var.region
  zone          = var.zone
}

provider "google-beta" {
 # credentials  = file("${var.credentialsfile}")
 # project      = var.project_id
  region        = var.region
  zone          = var.zone
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
  depends_on      = [random_id.id]

  provisioner "local-exec" {
    command = "sleep ${var.wait-time}"
  }
}

resource "google_project_service" "service" {
  for_each = toset([
    "cloudapis.googleapis.com",
    "container.googleapis.com",
    "appengine.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com",
    "run.googleapis.com"
  ])

  service = each.key

  project             = google_project.project.project_id
  disable_on_destroy  = false
  depends_on          = [google_project.project]
}

/*

resource "null_resource" "resource-to-wait-on" {
  provisioner "local-exec" {
    command = "sleep var.wait-time"
  }
  depends_on = [
    google_project_service.service["cloudapis.googleapis.com"],
    google_project_service.service["appengine.googleapis.com"],
    google_project_service.service["cloudbuild.googleapis.com"],
    google_project_service.service["cloudfunctions.googleapis.com"],
    google_project_service.service["cloudscheduler.googleapis.com"],
    google_project_service.service["run.googleapis.com"]
  ]
}

module "buckets" {
      source      = "./modules/buckets" 
      project_id  = google_project.project.project_id
      region      = var.region
}

module "cloud_functions" {
    source          = "./modules/cloudfunctions" 
    project_id      = google_project.project.project_id
    region          = var.region
    bucketname      = module.buckets.bucketname
    schedule_cron   = var.schedule_cron
}

module "cloud_build" {
    source      = "./modules/cloudbuild" 
    project_id  = google_project.project.project_id
}

module "cloud_run" {
    source      = "./modules/cloudrun" 
    project_id  = google_project.project.project_id
}
*/