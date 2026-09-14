# ==============================================================================
# Google Cloud Gemini Enterprise App - Provider Configuration
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.49.2"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 7.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
  }
}

provider "google" {
  project               = "ai-work-445217"
  region                = "us"
  user_project_override = true
  billing_project       = "ai-work-445217"
}

provider "google-beta" {
  project               = "ai-work-445217"
  region                = "us"
  user_project_override = true
  billing_project       = "ai-work-445217"
}