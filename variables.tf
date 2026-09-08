# ==============================================================================
# Google Cloud Gemini Enterprise App - Variables Definition
# ==============================================================================

variable "project_id" {
  description = "The Google Cloud Project ID where all resources will be provisioned."
  type        = string

  validation {
    condition     = length(var.project_id) > 0
    error_message = "The project_id must not be empty."
  }
}

variable "region" {
  description = "The Google Cloud compute region for regional resources (e.g., BigQuery dataset, Model Armor)."
  type        = string
  default     = "us"
}

variable "location" {
  description = "The Discovery Engine and Gemini Enterprise App location (e.g., 'global', 'us', 'eu')."
  type        = string
  default     = "global"
}

variable "model_armor_location" {
  description = "The geographic location where Model Armor security templates reside (e.g., 'us-central1' or 'global')."
  type        = string
  default     = "us-central1"
}

# ------------------------------------------------------------------------------
# Data Store Configuration
# ------------------------------------------------------------------------------

variable "data_store_id" {
  description = "Unique identifier for the Discovery Engine Data Store."
  type        = string
  default     = "my_demo_ds"
}

variable "data_store_display_name" {
  description = "Human-readable display name for the Discovery Engine Data Store."
  type        = string
  default     = "My Demo Data Store"
}

variable "content_config" {
  description = "Content configuration mode for the Data Store ('NO_CONTENT', 'CONTENT_REQUIRED', or 'PUBLIC_WEBSITE')."
  type        = string
  default     = "NO_CONTENT"
}

# ------------------------------------------------------------------------------
# Gemini Enterprise App (Search Engine) Configuration
# ------------------------------------------------------------------------------

variable "engine_id" {
  description = "Unique identifier for the Gemini Enterprise App / Search Engine."
  type        = string
  default     = "my_demo_app"
}

variable "engine_display_name" {
  description = "Display name for the Gemini Enterprise Intranet Application."
  type        = string
  default     = "My Demo Gemini Enterprise App"
}

variable "collection_id" {
  description = "The Discovery Engine collection ID under which the engine is created."
  type        = string
  default     = "default_collection"
}

variable "company_name" {
  description = "Corporate or organization entity name shown in the Gemini Enterprise App portal."
  type        = string
  default     = "Enterprise"
}

# ------------------------------------------------------------------------------
# Feature Management Configuration
# ------------------------------------------------------------------------------

variable "feature_management" {
  description = "Map of Gemini Enterprise features to toggle ON or OFF ('FEATURE_STATE_ON' or 'FEATURE_STATE_OFF')."
  type        = map(string)
  default = {
    "agent-gallery"          = "FEATURE_STATE_ON"
    "agent-designer"         = "FEATURE_STATE_ON"
    "prompt-gallery"         = "FEATURE_STATE_ON"
    "model-selector"         = "FEATURE_STATE_ON"
    "notebook-lm"            = "FEATURE_STATE_ON"
    "session-sharing"        = "FEATURE_STATE_ON"
    "personalization-memory" = "FEATURE_STATE_ON"
    "canvas"                 = "FEATURE_STATE_ON"
    "image-generation"       = "FEATURE_STATE_ON"
    "video-generation"       = "FEATURE_STATE_ON"
  }
}

# ------------------------------------------------------------------------------
# Agent / Assistant Configuration
# ------------------------------------------------------------------------------

variable "assistant_id" {
  description = "Unique identifier for the Gemini Enterprise Assistant / Agent."
  type        = string
  default     = "my_demo_agent"
}

variable "assistant_display_name" {
  description = "Display name for the Gemini Enterprise Assistant / Agent."
  type        = string
  default     = "My Demo Agent"
}

# ------------------------------------------------------------------------------
# Observability and Audit Logging Configuration
# ------------------------------------------------------------------------------

variable "log_sink_name" {
  description = "Name of the Cloud Logging project sink capturing Discovery Engine and Model Armor logs."
  type        = string
  default     = "ge-discovery-engine-sink"
}

variable "bigquery_dataset_id" {
  description = "Identifier for the secure BigQuery dataset storing Discovery Engine prompt and response audit logs."
  type        = string
  default     = "gemini_enterprise_logs"
}

variable "bigquery_dataset_location" {
  description = "Geographic location for the BigQuery audit log dataset (e.g., 'US', 'EU')."
  type        = string
  default     = "US"
}

variable "log_retention_days" {
  description = "Default table retention in days for BigQuery log records (e.g., 90 days for compliance)."
  type        = number
  default     = 90
}
