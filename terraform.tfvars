# ==============================================================================
# Google Cloud Gemini Enterprise App - Terraform Variables (terraform.tfvars)
# ==============================================================================
# Generated based on Step 3 of execution.md.

# ------------------------------------------------------------------------------
# 1. Core Project Configuration
# ------------------------------------------------------------------------------
project_id           = "wortz-project-352116"
region               = "us"
location             = "global"
model_armor_location = "us-central1"
company_name         = "Enterprise Corp Dome"

# ------------------------------------------------------------------------------
# 2. Data Store Configuration
# ------------------------------------------------------------------------------
data_store_id           = "terraform_instance_ge_ds"
data_store_display_name = "Terraform Instance GE Data Store"
content_config          = "NO_CONTENT"

# ------------------------------------------------------------------------------
# 3. Gemini Enterprise App (Engine) & Assistant Configuration
# ------------------------------------------------------------------------------
engine_id           = "terraform-instance-ge"
engine_display_name = "Terraform Instance GE"
collection_id       = "default_collection"

assistant_id           = "terraform_instance_ge_agent"
assistant_display_name = "Terraform Instance GE Agent"

# ------------------------------------------------------------------------------
# 4. Feature Management Configuration (All 10 Features Active)
# ------------------------------------------------------------------------------
feature_management = {
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

# ------------------------------------------------------------------------------
# 5. Observability & Audit Logging Configuration
# ------------------------------------------------------------------------------
log_sink_name             = "ge-discovery-engine-sink"
bigquery_dataset_id       = "gemini_enterprise_logs"
bigquery_dataset_location = "US"
log_retention_days        = 90

# ------------------------------------------------------------------------------
# 6. Jira Data Connector Configuration
# ------------------------------------------------------------------------------
jira_collection_id           = "jira-federated_1782320633397"
jira_collection_display_name = "jira-federated"
jira_site                    = "https://jwortz.atlassian.net"

