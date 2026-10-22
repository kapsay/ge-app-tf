# ==============================================================================
# Google Discovery Engine Search Engine / Collection Variables
# ==============================================================================

variable "project_id" {
  description = "The GCP Project ID where the Discovery Engine search engine and connector reside."
  type        = string
}

variable "location" {
  description = "The location of the Discovery Engine search engine and connector (e.g., 'global', 'us', 'eu')."
  type        = string
  default     = "global"
}

variable "collection_id" {
  description = "The collection ID for the Discovery Engine search engine."
  type        = string
  default     = "default_collection"
}

variable "kms_key_name" {
  description = "Optional Cloud KMS encryption key resource name to protect DataStores managed by this connector (for CMEK compliance)."
  type        = string
  default     = ""
}

# ==============================================================================
# ServiceNow Data Connector Specific Variables
# Reference: https://docs.cloud.google.com/gemini/enterprise/docs/connectors/servicenow/set-up-data-store
# ==============================================================================

variable "servicenow_collection_display_name" {
  description = "Collection display name for the ServiceNow Data Connector."
  type        = string
  default     = "Kroger ServiceNow Data Connector"
}

variable "servicenow_data_source" {
  description = "Data source identifier for the ServiceNow Data Connector. Must be 'servicenow'."
  type        = string
  default     = "servicenow"
}

variable "servicenow_data_source_version" {
  description = "Data source version for ServiceNow (version 3 for modern Discovery Engine connectors)."
  type        = number
  default     = 3
}

variable "servicenow_instance_uri" {
  description = "Base instance URL of your ServiceNow site (e.g., 'https://your-instance.service-now.com'). Must include the https:// scheme."
  type        = string
}

variable "servicenow_client_id" {
  description = "ServiceNow OAuth Client ID created in System OAuth > Application Registry."
  type        = string
  sensitive   = true
}

variable "servicenow_client_secret" {
  description = "ServiceNow OAuth Client Secret. Note: ServiceNow secrets must be alphanumeric."
  type        = string
  sensitive   = true
}

variable "servicenow_user_account" {
  description = "ServiceNow user account / email for ingestion credentials (ROPC / OAuth Password Grant). Required when using DATA_INGESTION mode; not required for FEDERATED mode."
  type        = string
  default     = ""
}

variable "servicenow_password" {
  description = "ServiceNow user password for ingestion credentials (ROPC / OAuth Password Grant). Required when using DATA_INGESTION mode; not required for FEDERATED mode."
  type        = string
  sensitive   = true
  default     = ""
}

variable "servicenow_auth_type" {
  description = "Authentication grant type for the primary connector: 'OAUTH_PASSWORD_GRANT' for Data Ingestion (ROPC) or 'OAUTH' for Federated search."
  type        = string
  default     = "OAUTH_PASSWORD_GRANT"
}

variable "servicenow_auth_uri" {
  description = "ServiceNow OAuth authorization endpoint. Defaults to '{instance_uri}/oauth_auth.do' if empty, as documented in ServiceNow OAuth setup."
  type        = string
  default     = ""
}

variable "servicenow_token_uri" {
  description = "ServiceNow OAuth token endpoint. Defaults to '{instance_uri}/oauth_token.do' if empty, as documented in ServiceNow OAuth setup."
  type        = string
  default     = ""
}

variable "servicenow_static_ip_enabled" {
  description = "Whether to route ServiceNow connector traffic through dedicated static IP addresses for firewall allowlisting. Default is false."
  type        = bool
  default     = false
}

variable "servicenow_url_suffix" {
  description = "Optional URL suffix from Knowledge or Catalog portal links (e.g., 'sp' for ServiceNow Service Portal, https://{instance}.service-now.com/sp). If left empty (\"\"), standard native ServiceNow UI links are used."
  type        = string
  default     = ""
}

variable "servicenow_max_qps" {
  description = "Optional maximum queries per second rate limit to send to the ServiceNow instance (e.g., '100'). If left empty (\"\"), no client-side rate limit throttling is enforced by Discovery Engine."
  type        = string
  default     = ""
}

variable "servicenow_sync_since" {
  description = "Optional ISO date filter (YYYY-MM-DD) to only sync incidents created on or after this date forward. If empty, all historical records are synced."
  type        = string
  default     = ""
}

variable "servicenow_refresh_interval" {
  description = "Refresh interval for ServiceNow Data Connector full sync. Minimum is 30 minutes ('1800s'), maximum is 7 days. Default is 24 hours ('86400s')."
  type        = string
  default     = "86400s"
}

variable "servicenow_incremental_refresh_interval" {
  description = "Refresh interval for ServiceNow Data Connector incremental data syncs. Default is 6 hours ('21600s'). When set to the same value as refresh_interval, incremental sync is disabled."
  type        = string
  default     = "21600s"
}

variable "servicenow_destination_key" {
  description = "Destination config key identifier. Typically 'url'."
  type        = string
  default     = "url"
}

variable "servicenow_destination_host" {
  description = "Destination host URL (ServiceNow instance URL). Required for both Federated search and Data Ingestion."
  type        = string
}

variable "servicenow_destination_port" {
  description = "Destination port number. Port is not used by ServiceNow and defaults to 0."
  type        = number
  default     = 0
}

variable "servicenow_connector_modes" {
  description = "Connector modes for ServiceNow. Supported options: ['FEDERATED', 'ACTIONS'] for real-time live queries without data ingestion (matching Jira connector), or ['DATA_INGESTION', 'ACTIONS'] for synchronizing and indexing records into Gemini Enterprise."
  type        = list(string)
  default     = ["DATA_INGESTION", "ACTIONS"]
}

variable "servicenow_sync_mode" {
  description = "Sync mode for ServiceNow Data Connector. Default is 'PERIODIC'."
  type        = string
  default     = "PERIODIC"
}

variable "servicenow_auto_run_disabled" {
  description = "Whether full sync auto run is paused. Default is true to allow initial manual verification."
  type        = bool
  default     = true
}

variable "servicenow_incremental_sync_disabled" {
  description = "Whether incremental sync is paused. Default is true to allow initial manual verification."
  type        = bool
  default     = true
}

# ==============================================================================
# ServiceNow BAP & Action Configuration Variables
# Reference: https://docs.cloud.google.com/gemini/enterprise/docs/connectors/servicenow#supported-actions
# ==============================================================================

variable "servicenow_create_bap_connection" {
  description = "Whether to create a BAP (Business Application Platform) connection for action execution. Default is true."
  type        = bool
  default     = true
}

variable "servicenow_action_instance_uri" {
  description = "ServiceNow instance URL for actions. If empty, servicenow_instance_uri is used automatically."
  type        = string
  default     = ""
}

variable "servicenow_action_client_id" {
  description = "ServiceNow OAuth Client ID for actions (Authorization Code grant). If empty, servicenow_client_id is used."
  type        = string
  sensitive   = true
  default     = ""
}

variable "servicenow_action_client_secret" {
  description = "ServiceNow OAuth Client Secret for actions (Authorization Code grant). If empty, servicenow_client_secret is used."
  type        = string
  sensitive   = true
  default     = ""
}

variable "servicenow_action_auth_type" {
  description = "Authentication grant type for ServiceNow actions. Uses 'OAUTH' (OAuth Authorization Code grant)."
  type        = string
  default     = "OAUTH"
}

variable "servicenow_action_auth_uri" {
  description = "ServiceNow OAuth authorization endpoint for actions. Defaults to '{instance_uri}/oauth_auth.do' if empty."
  type        = string
  default     = ""
}

variable "servicenow_action_token_uri" {
  description = "ServiceNow OAuth token endpoint for actions. Defaults to '{instance_uri}/oauth_token.do' if empty."
  type        = string
  default     = ""
}

variable "servicenow_action_include_system_tables" {
  description = "Controls whether to expose ServiceNow system tables (prefixed with 'sys_') for actions. Defaults to false for least-privilege compliance."
  type        = bool
  default     = false
}

variable "servicenow_action_portal_suffix" {
  description = "Optional default URL suffix for action portal redirection (e.g., 'sp')."
  type        = string
  default     = ""
}

variable "servicenow_action_knowledge_portal_suffix" {
  description = "Optional URL suffix for knowledge portal (e.g., 'kb')."
  type        = string
  default     = ""
}

variable "servicenow_action_catalog_portal_suffix" {
  description = "Optional URL suffix for catalog portal (e.g., 'csm')."
  type        = string
  default     = ""
}

variable "servicenow_action_incident_portal_suffix" {
  description = "Optional URL suffix for incident portal (e.g., 'ip')."
  type        = string
  default     = ""
}

variable "servicenow_action_public_host_url" {
  description = "Optional public host URL of your ServiceNow instance for constructing user-facing links (e.g., 'https://public-portal.company.com')."
  type        = string
  default     = ""
}

variable "servicenow_bap_supported_connector_modes" {
  description = "Supported connector modes for BAP config."
  type        = list(string)
  default     = ["ACTIONS"]
}

variable "servicenow_bap_enabled_actions" {
  description = "List of enabled actions for ServiceNow BAP config. Core actions from documentation: 'create_incident', 'update_incident'. Optional extensions: 'create_change_request', 'create_task', 'create_service_catalog_request', 'update_service_catalog_request', 'create_request_item', 'update_request_item', 'submit_catalog_item', 'approve_record'."
  type        = list(string)
  default = [
    "create_incident",
    "update_incident",
  ]
}

# ==============================================================================
# Entities Configuration Variables
# ==============================================================================

variable "servicenow_entities" {
  description = "List of entity names to sync or federate for ServiceNow. Supported entities: 'incident', 'knowledge_base', 'catalog', 'knowledge', 'users', 'attachment'."
  type        = list(string)
  default = [
    "incident",
    "knowledge_base",
    "catalog",
    "knowledge",
    "users",
    "attachment",
  ]
}

variable "servicenow_entity_configs" {
  description = "Optional advanced entity configurations allowing inclusion/exclusion filters (e.g., 'knowledgeBaseSysId', 'catalogSysId') and key_property_mappings. If defined, overrides servicenow_entities."
  type = list(object({
    entity_name           = string
    params                = optional(string)
    key_property_mappings = optional(map(string))
  }))
  default = []
}
