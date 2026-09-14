# ==============================================================================
# Terraform Variable Values
# ==============================================================================

project_id        = "<Your Project ID>"
project_num       = "<Your Project NUM>"
location          = "global"
collection_id     = "kroger_collection"
engine_id         = "kroger_demo_app_tf"

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

dc_entity_name           = "mcp_data"
dc_key_property_mappings = {}