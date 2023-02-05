resource "google_bigquery_dataset" "test_dataset" {
  dataset_id    = "test-dataset"
  description   = "This is a test dataset"
  location      = "US"
}

resource "google_bigquery_table" "source_table" {
  dataset_id = google_bigquery_dataset.test_dataset.dataset_id
  table_id   = "test-table"
  schema = file("schema/dev/schema-example.json")
}

resource "google_bigquery_data_transfer_config" "query_config" {
  depends_on = [google_project_iam_member.permissions, google_project_iam_member.bq-scheduler-iam]
  display_name           = "my-query"
  location               = "US"
  data_source_id         = "scheduled-query"
  schedule               = "every 15 mins"
  destination_dataset_id = google_bigquery_dataset.test_dataset.dataset_id
  params = {
    destination_table_name_template = "test-table"
    write_disposition               = "WRITE_APPEND"
    query                           =  file("sql/dev/dev-example.sql")
  }
}

data "google_service_account" "bq-scheduler-terraform" {
  account_id   = "bq-scheduler-terraform@<project-id>.iam.gserviceaccount.com"
}
 
resource "google_project_iam_member" "bq-scheduler-iam" {
  depends_on = [data.google_service_account.bq-scheduler-terraform]
  project    = var.project_id
  role       = "roles/bigquery.admin"
  member     = "serviceAccount:bq-scheduler-terraform@<project-id>.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "permissions" {
  project    = var.project_id
  role   = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:permission-terraform@<project-id>.iam.gserviceaccount.com"
}