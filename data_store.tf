# ==============================================================================
# Discovery Engine Data Store Configuration
# ==============================================================================
# Provisions the foundational Data Store configured for conversational chat solutions.

resource "google_discovery_engine_data_store" "my_demo_ds" {
  provider                    = google-beta
  project                     = var.project_id
  location                    = var.location
  data_store_id               = var.data_store_id
  display_name                = var.data_store_display_name
  industry_vertical           = "GENERIC"
  content_config              = var.content_config
  solution_types              = ["SOLUTION_TYPE_CHAT"]
  create_advanced_site_search = false
}
