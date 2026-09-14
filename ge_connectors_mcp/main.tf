# ==============================================================================
# Google Discovery Engine Data Store Configuration (MCP / developer-docs)
# ==============================================================================

resource "google_discovery_engine_data_store" "dc_mcp" {
  project           = var.project_id
  location          = var.location
  data_store_id     = var.mcp_data_store_id
  display_name      = var.mcp_data_store_display_name
  industry_vertical = var.mcp_data_store_industry_vertical
  solution_types    = var.mcp_data_store_solution_types
  deletion_policy   = var.mcp_data_store_deletion_policy
  default_schema_id = var.mcp_data_store_default_schema_id
}
