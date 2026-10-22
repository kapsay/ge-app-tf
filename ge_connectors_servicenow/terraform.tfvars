# ==============================================================================
# Terraform Variable Values - ServiceNow Data Connector
# Reference: https://docs.cloud.google.com/gemini/enterprise/docs/connectors/servicenow/set-up-data-store
# Third-party OAuth Setup: https://docs.cloud.google.com/gemini/enterprise/docs/connectors/servicenow/third-party-config
# ==============================================================================

project_id    = "<Your Project ID>"
location      = "global"
collection_id = "kroger_collection"

# ------------------------------------------------------------------------------
# ServiceNow General & Destination Configuration
# ------------------------------------------------------------------------------
servicenow_collection_display_name = "Kroger ServiceNow Data Connector"
servicenow_data_source             = "servicenow"
servicenow_data_source_version     = 3
servicenow_instance_uri            = "<Your ServiceNow Instance URI>" # e.g. https://your-instance.service-now.com
servicenow_client_id               = "<Your Client ID>"
servicenow_client_secret           = "<Your Client Secret>"

# Destination config host URL (ServiceNow instance URL)
servicenow_destination_key  = "url"
servicenow_destination_host = "<Your ServiceNow Instance URI>"
servicenow_destination_port = 0

# ------------------------------------------------------------------------------
# Connector Modes: Choose Option A (Federated) or Option B (Data Ingestion)
# ------------------------------------------------------------------------------

# --- OPTION A: Federated Search & Actions (Live Real-time Search, No Data Ingestion) ---
# Mirrors ge_connectors_jira architecture:
# servicenow_connector_modes = ["FEDERATED", "ACTIONS"]
# servicenow_auth_type       = "OAUTH" # Authorization Code flow; user_account & password are NOT required

# --- OPTION B: Data Ingestion & Actions (Indexes data into Gemini Enterprise data store) ---
servicenow_connector_modes = ["DATA_INGESTION", "ACTIONS"]
servicenow_auth_type       = "OAUTH_PASSWORD_GRANT"           # ROPC grant type for ingestion
servicenow_user_account    = "<Your Ingestion User Account>"  # e.g. admin or integration service account
servicenow_password        = "<Your Ingestion User Password>" # Ingestion user password

# ------------------------------------------------------------------------------
# Sync Schedule & Throttling (Data Ingestion Mode)
# ------------------------------------------------------------------------------
servicenow_sync_mode                    = "PERIODIC"
servicenow_refresh_interval             = "86400s" # Full sync interval (24h)
servicenow_incremental_refresh_interval = "21600s" # Incremental sync interval (6h)
servicenow_auto_run_disabled            = true
servicenow_incremental_sync_disabled    = true
servicenow_static_ip_enabled            = false

# Optional advanced tuning:
# servicenow_max_qps    = "100"       # Rate limit on queries per second sent to ServiceNow (empty = unthrottled)
# servicenow_url_suffix = "sp"        # Portal URL suffix (e.g., 'sp' for ServiceNow Service Portal)
# servicenow_sync_since = "2026-01-01" # Only sync incidents created on or after this date

# ------------------------------------------------------------------------------
# Actions Configuration (BAP)
# ------------------------------------------------------------------------------
servicenow_create_bap_connection        = true
servicenow_action_auth_type             = "OAUTH" # Authorization Code grant for actions
servicenow_action_include_system_tables = false   # Set true only if exposing sys_* system tables

# Auth & Token endpoints (automatically derived from instance_uri if left empty):
# servicenow_action_auth_uri  = "https://your-instance.service-now.com/oauth_auth.do"
# servicenow_action_token_uri = "https://your-instance.service-now.com/oauth_token.do"

# Optional action portal routing suffixes:
# servicenow_action_portal_suffix          = "sp"
# servicenow_action_incident_portal_suffix = "ip"
# servicenow_action_knowledge_portal_suffix = "kb"
# servicenow_action_catalog_portal_suffix   = "csm"

servicenow_bap_supported_connector_modes = ["ACTIONS"]
servicenow_bap_enabled_actions = [
  "create_incident",
  "update_incident",
  # "create_change_request",
  # "create_task",
  # "create_service_catalog_request",
  # "update_service_catalog_request",
  # "create_request_item",
  # "update_request_item",
  # "submit_catalog_item",
  # "approve_record",
]

# ------------------------------------------------------------------------------
# Entities Configuration
# ------------------------------------------------------------------------------
# Default entity list:
servicenow_entities = [
  "incident",
  "knowledge_base",
  "catalog",
  "knowledge",
  "users",
  "attachment",
]

# Advanced entity configuration with inclusion filters (optional, overrides servicenow_entities if set):
# servicenow_entity_configs = [
#   {
#     entity_name = "catalog"
#     params      = jsonencode({ "inclusion_filters" : { "catalogSysId" : ["<sys_id_1>", "<sys_id_2>"] } })
#     key_property_mappings = { title = "title", description = "short_description" }
#   },
#   {
#     entity_name = "incident"
#     params      = jsonencode({ "inclusion_filters" : { "knowledgeBaseSysId" : ["<sys_id>"] } })
#     key_property_mappings = null
#   },
#   {
#     entity_name = "knowledge_base"
#     params      = jsonencode({ "inclusion_filters" : { "knowledgeBaseSysId" : ["<sys_id>"] } })
#     key_property_mappings = null
#   }
# ]
