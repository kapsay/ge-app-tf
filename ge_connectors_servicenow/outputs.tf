# ==============================================================================
# ServiceNow Data Connector Outputs
# ==============================================================================

output "connector_id" {
  description = "The ID of the ServiceNow data connector."
  value       = google_discovery_engine_data_connector.servicenow-with-actions.id
}

output "connector_name" {
  description = "The resource name of the ServiceNow data connector."
  value       = google_discovery_engine_data_connector.servicenow-with-actions.name
}

output "connector_state" {
  description = "The state of the ServiceNow data connector."
  value       = google_discovery_engine_data_connector.servicenow-with-actions.state
}

output "data_stores" {
  description = "The data stores automatically created for ServiceNow entities."
  value       = google_discovery_engine_data_connector.servicenow-with-actions.entities[*].data_store
}
