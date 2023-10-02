terraform {
  required_version = "= 1.5.7"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "google" {
  project = var.project
}

provider "random" {
}