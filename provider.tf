terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.00"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
