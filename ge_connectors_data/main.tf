# ==============================================================================
# Google Discovery Engine Data Store Configuration (BigQuery / ecomm_events)
# ==============================================================================

resource "google_discovery_engine_data_store" "dc_bq" {
  project           = var.project_id
  location          = var.location
  data_store_id     = var.bq_data_store_id
  display_name      = var.bq_data_store_display_name
  industry_vertical = var.bq_data_store_industry_vertical
  solution_types    = var.bq_data_store_solution_types
  deletion_policy   = var.bq_data_store_deletion_policy
  default_schema_id = var.bq_data_store_default_schema_id

  document_processing_config {
    default_parsing_config {
      layout_parsing_config {
        enable_get_processed_document = var.bq_data_store_layout_parsing_config.enable_get_processed_document
        enable_image_annotation       = var.bq_data_store_layout_parsing_config.enable_image_annotation
        enable_llm_layout_parsing     = var.bq_data_store_layout_parsing_config.enable_llm_layout_parsing
        enable_table_annotation       = var.bq_data_store_layout_parsing_config.enable_table_annotation
      }
    }
  }
}
