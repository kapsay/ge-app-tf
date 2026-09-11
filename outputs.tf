# ==============================================================================
# Gemini Enterprise App - Terraform Outputs
# ==============================================================================

# ------------------------------------------------------------------------------
# Model Armor Outputs
# ------------------------------------------------------------------------------
output "model_armor_template_id" {
  description = "The ID of the provisioned Model Armor template."
  value       = google_model_armor_template.ge_model_armor_template.template_id
}

output "model_armor_template_name" {
  description = "The fully qualified Google Cloud resource name of the Model Armor template."
  value       = google_model_armor_template.ge_model_armor_template.name
}

output "model_armor_location" {
  description = "The region/location where the Model Armor template resides."
  value       = google_model_armor_template.ge_model_armor_template.location
}

# ------------------------------------------------------------------------------
# Discovery Engine Data Store Outputs
# ------------------------------------------------------------------------------
output "data_store_id" {
  description = "The unique ID of the Discovery Engine Data Store."
  value       = google_discovery_engine_data_store.my_demo_ds.data_store_id
}

output "data_store_name" {
  description = "The fully qualified resource name of the Discovery Engine Data Store."
  value       = google_discovery_engine_data_store.my_demo_ds.name
}

# ------------------------------------------------------------------------------
# Gemini Enterprise Search Engine (App) Outputs
# ------------------------------------------------------------------------------
output "engine_id" {
  description = "The unique ID of the Gemini Enterprise Search Engine (Intranet App)."
  value       = google_discovery_engine_search_engine.my_demo_app.engine_id
}

output "engine_name" {
  description = "The fully qualified resource name of the Gemini Enterprise Search Engine."
  value       = google_discovery_engine_search_engine.my_demo_app.name
}

output "engine_app_type" {
  description = "Application type of the engine."
  value       = "APP_TYPE_INTRANET"
}

# ------------------------------------------------------------------------------
# AI Agent / Assistant Outputs
# ------------------------------------------------------------------------------
output "assistant_id" {
  description = "The unique identifier of the Gemini Enterprise AI Assistant."
  value       = var.assistant_id
}

output "assistant_display_name" {
  description = "The display name of the Gemini Enterprise AI Assistant."
  value       = var.assistant_display_name
}

# ------------------------------------------------------------------------------
# Service Agents & IAM Outputs
# ------------------------------------------------------------------------------
output "discovery_engine_service_account" {
  description = "Email of the Discovery Engine service agent used for IAM bindings."
  value       = google_project_service_identity.discovery_engine_sa.email
}

output "model_armor_service_account" {
  description = "Email of the Model Armor service agent used for IAM bindings."
  value       = google_project_service_identity.model_armor_sa.email
}

# ------------------------------------------------------------------------------
# Observability & Audit Logging Outputs
# ------------------------------------------------------------------------------
output "bigquery_audit_dataset_id" {
  description = "BigQuery dataset ID storing prompt and response audit logs."
  value       = google_bigquery_dataset.ge_audit_logs.dataset_id
}

output "bigquery_audit_dataset_uri" {
  description = "URI of the BigQuery audit logs dataset."
  value       = "bigquery.googleapis.com/${google_bigquery_dataset.ge_audit_logs.id}"
}

output "cloud_logging_sink_name" {
  description = "Name of the Cloud Logging project sink routing audit payloads."
  value       = google_logging_project_sink.discovery_engine_sink.name
}

output "cloud_logging_sink_writer_identity" {
  description = "Service account writer identity of the Cloud Logging export sink."
  value       = google_logging_project_sink.discovery_engine_sink.writer_identity
}

# ------------------------------------------------------------------------------
# Jira Data Connector Outputs
# ------------------------------------------------------------------------------
output "jira_connector_id" {
  description = "The unique resource identifier of the Jira Data Connector."
  value       = google_discovery_engine_data_connector.jira_federated.id
}

output "jira_connector_name" {
  description = "The fully qualified resource name of the Jira Data Connector."
  value       = google_discovery_engine_data_connector.jira_federated.name
}

output "jira_collection_id" {
  description = "The collection ID where the Jira Data Connector resides."
  value       = google_discovery_engine_data_connector.jira_federated.collection_id
}

output "jira_connector_state" {
  description = "Current lifecycle state of the Jira Data Connector."
  value       = google_discovery_engine_data_connector.jira_federated.state
}

output "jira_connector_action_state" {
  description = "Action state of the Jira Data Connector (e.g., ACTIVE)."
  value       = google_discovery_engine_data_connector.jira_federated.action_state
}

output "jira_data_stores" {
  description = "Map of Jira entities to their automatically provisioned Discovery Engine Data Stores."
  value = {
    for entity in google_discovery_engine_data_connector.jira_federated.entities :
    entity.entity_name => entity.data_store
  }
}

