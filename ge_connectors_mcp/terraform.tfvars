# ==============================================================================
# Terraform Variable Values
# ==============================================================================

project_id        = "ai-work-445217"
project_num       = "545804763087"
location          = "global"
collection_id     = "kroger_collection"
engine_id         = "kroger_demo_app_tf"
display_name      = "Kroger Demo App via Terraform"
app_type          = "APP_TYPE_INTRANET"
industry_vertical = "GENERIC"
deletion_policy   = "DELETE"
disable_analytics = false
company_name      = "The Kroger Co."

data_store_ids = [
  "ecomm-events_1780862168950",
  "developer-docs_1784867512211_mcp_data", 
]

features = {
  "agent-gallery"                        = "FEATURE_STATE_ON"
  "agent-sharing-without-admin-approval" = "FEATURE_STATE_OFF"
  "bi-directional-audio"                 = "FEATURE_STATE_OFF"
  "cross-product-intelligence"           = "FEATURE_STATE_OFF"
  "disable-agent-sharing"                = "FEATURE_STATE_OFF"
  "disable-canvas"                       = "FEATURE_STATE_OFF"
  "disable-canvas-workspace"             = "FEATURE_STATE_OFF"
  "disable-google-drive-upload"          = "FEATURE_STATE_OFF"
  "disable-image-generation"             = "FEATURE_STATE_OFF"
  "disable-mobile-app-access"            = "FEATURE_STATE_OFF"
  "disable-onedrive-upload"              = "FEATURE_STATE_OFF"
  "disable-skills"                       = "FEATURE_STATE_OFF"
  "disable-talk-to-content"              = "FEATURE_STATE_OFF"
  "disable-video-generation"             = "FEATURE_STATE_OFF"
  "disable-welcome-emails"               = "FEATURE_STATE_OFF"
  "enable-end-user-sharing-with-groups"  = "FEATURE_STATE_OFF"
  "in-app-notifications"                 = "FEATURE_STATE_OFF"
  "model-selector"                       = "FEATURE_STATE_ON"
  "no-code-agent-builder"                = "FEATURE_STATE_ON"
  "notebook-lm"                          = "FEATURE_STATE_ON"
  "people-search-org-chart"              = "FEATURE_STATE_ON"
  "personalization-memory"               = "FEATURE_STATE_ON"
  "personalization-suggested-highlights" = "FEATURE_STATE_ON"
  "prompt-gallery"                       = "FEATURE_STATE_ON"
  "session-sharing"                      = "FEATURE_STATE_OFF"
}

knowledge_graph_config = {
  cloud_knowledge_graph_types    = []
  enable_cloud_knowledge_graph   = false
  enable_private_knowledge_graph = true
}

search_engine_config = {
  required_subscription_tier = "SUBSCRIPTION_TIER_SEARCH_AND_ASSISTANT"
  search_add_ons             = ["SEARCH_ADD_ON_LLM"]
  search_tier                = "SEARCH_TIER_ENTERPRISE"
}

# BigQuery Data Store (ge_dc_bq)
bq_data_store_id                 = "kroger_demo_ds_bq"
bq_data_store_display_name       = "ecomm_events"
bq_data_store_industry_vertical  = "GENERIC"
bq_data_store_solution_types     = ["SOLUTION_TYPE_SEARCH"]
bq_data_store_acl_enabled        = false
bq_data_store_deletion_policy    = "DELETE"
bq_data_store_default_schema_id  = "default_schema"

bq_data_store_layout_parsing_config = {
  enable_get_processed_document = false
  enable_image_annotation       = false
  enable_llm_layout_parsing     = false
  enable_table_annotation       = false
}

# MCP Data Store (ge_dc_mcp)
mcp_data_store_id                = "kroger_demo_ds_mcp"
mcp_data_store_display_name      = "mcp_data"
mcp_data_store_industry_vertical = "GENERIC"
mcp_data_store_solution_types    = ["SOLUTION_TYPE_SEARCH"]
mcp_data_store_acl_enabled       = false
mcp_data_store_deletion_policy   = "DELETE"
mcp_data_store_default_schema_id = "default_schema"

# Data Connector (ge_dc_jira_etc)
dc_collection_display_name = "kroger_collection display name"
dc_connector_modes         = ["FEDERATED"]
dc_connector_type          = "THIRD_PARTY_FEDERATED"
dc_data_source             = "custom_mcp"
dc_deletion_policy         = "DELETE"
dc_refresh_interval        = "86400s"
dc_static_ip_enabled       = false

dc_action_config = {
  action_params         = {}
  create_bap_connection = false
  is_action_configured  = false
}

dc_bap_config = {
  enabled_actions           = ["answer_query", "get_documents", "search_documents"]
  supported_connector_modes = []
}

dc_entity_data_store     = "projects/545804763087/locations/global/collections/kroger_collection/dataStores/kroger_demo_ds_mcp"
dc_entity_name           = "mcp_data"
dc_key_property_mappings = {}



