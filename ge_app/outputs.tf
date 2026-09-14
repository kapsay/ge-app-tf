# ==============================================================================
# Google Discovery Engine Search Engine Outputs
# ==============================================================================

output "search_engine_id" {
  description = "The ID of the created Discovery Engine search engine."
  value       = google_discovery_engine_search_engine.default.id
}

output "search_engine_name" {
  description = "The fully-qualified resource name of the Discovery Engine search engine."
  value       = google_discovery_engine_search_engine.default.name
}
