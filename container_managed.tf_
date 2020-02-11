resource "google_cloud_run_service" "quarkus-getting-started" {
  project   = google_project.project.project_id
  name      = "quarkus-getting-started"
  location  = "europe-west1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        env {
          name = "DISABLE_SIGNAL_HANDLERS"
          value = "foobar"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [ google_project_service.service["run.googleapis.com" ] ]

}

resource "google_cloud_run_service" "nodejs-getting-started" {
  project   = google_project.project.project_id
  name      = "nodejs-getting-started"
  location  = "europe-west1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [ google_project_service.service["run.googleapis.com" ] ]

}