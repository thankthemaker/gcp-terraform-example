resource "google_cloudbuild_trigger" "hello_world_quarkus_build_trigger" {
  provider  = google
  project   = google_project.project.project_id
  trigger_template {
    project_id = google_project.project.project_id
    branch_name = "master"
    repo_name = "github_thankthemaker_quarkus-getting-started"
  }

 build {
   step {
     name = "gcr.io/cloud-builders/docker"
     args = ["build", "-t", "gcr.io/${google_project.project.project_id}/quarkus-getting-started", "-f",  "src/main/docker/Dockerfile.multistage", "."]
   }
   step {
      name =  "gcr.io/cloud-builders/docker"
      args = ["push", "gcr.io/${google_project.project.project_id}/quarkus-getting-started"]
   }
   step {
      name = "gcr.io/cloud-builders/gcloud"
      args = ["run", "deploy", "quarkus-getting-started", "--image", "gcr.io/${google_project.project.project_id}/quarkus-getting-started", "--region", "europe-west1", "--platform", "managed", "--allow-unauthenticated", "--set-env-vars", "DISABLE_SIGNAL_HANDLERS=foobar"]
   }
 }

depends_on = [ google_project_service.service["cloudbuild.googleapis.com" ] ]

}

resource "google_cloudbuild_trigger" "hello_world_nodejs_build_trigger" {
  provider  = google
  project   = google_project.project.project_id
  trigger_template {
    project_id = google_project.project.project_id
    branch_name = "master"
    repo_name = "github_thankthemaker_nodejs-getting-started"
  }

 build {
 #  step {
 #    name = "gcr.io/cloud-builders/npm"
 #    args = ["install"]
 #  }
   step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${google_project.project.project_id}/nodejs-getting-started", "-f",  "Dockerfile", "."]
   }
   step {
      name =  "gcr.io/cloud-builders/docker"
      args = ["push", "gcr.io/${google_project.project.project_id}/nodejs-getting-started"]
   }
   step {
      name = "gcr.io/cloud-builders/gcloud"
      args = ["run", "deploy", "nodejs-getting-started", "--image", "gcr.io/${google_project.project.project_id}/nodejs-getting-started", "--region", "europe-west1", "--platform", "managed", "--allow-unauthenticated", "--set-env-vars", "DISABLE_SIGNAL_HANDLERS=foobar"]
   }
 }

 depends_on = [ google_project_service.service["cloudbuild.googleapis.com" ] ]

}
