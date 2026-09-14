# ==============================================================================
# Google Discovery Engine Search Engine Resource Configuration
# ==============================================================================

resource "google_discovery_engine_search_engine" "kr_ge_app_tf" {
  project           = var.project_id
  location          = var.location
  collection_id     = var.collection_id
  engine_id         = var.engine_id
  display_name      = var.display_name
  app_type          = var.app_type
  industry_vertical = var.industry_vertical
  deletion_policy   = var.deletion_policy
  disable_analytics = var.disable_analytics
  data_store_ids    = var.data_store_ids
  features          = var.features

  common_config {
    company_name = var.company_name
  }

  knowledge_graph_config {
    cloud_knowledge_graph_types    = var.knowledge_graph_config.cloud_knowledge_graph_types
    enable_cloud_knowledge_graph   = var.knowledge_graph_config.enable_cloud_knowledge_graph
    enable_private_knowledge_graph = var.knowledge_graph_config.enable_private_knowledge_graph
  }

  search_engine_config {
    required_subscription_tier = var.search_engine_config.required_subscription_tier
    search_add_ons             = var.search_engine_config.search_add_ons
    search_tier                = var.search_engine_config.search_tier
  }
}
