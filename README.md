# gcp-terraform-example

export TF_CREDS=/Users/dgey/.config/gcloud/-terraform-admin.json
export TF_ADMIN=thankthemaker-terraform-admin
export TF_LOG=
export TF_VAR_billing_account=013321-6FD330-EDEDE0
export TF_VAR_org_id=645165730555


Deploy to GKE with Cloud Run on Anthos
'''
gcloud run deploy nodejs-getting-started --project gcptest7b9c0692 --image gcr.io/cloudrun/hello --cluster my-gke-cluster  --cluster-location europe-west3 --platform gke --set-env-vars DISABLE_SIGNAL_HANDLERS=foobar
'''