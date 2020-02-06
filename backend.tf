terraform {
 backend "gcs" {
   bucket  = "thankthemaker-terraform-admin"
   prefix  = "terraform/state"
 }
}
