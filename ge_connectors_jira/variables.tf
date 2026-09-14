# ==============================================================================
# Google Discovery Engine Search Engine Variables
# ==============================================================================

variable "project_id" {
  description = "The GCP Project ID where the Discovery Engine search engine will be created."
  type        = string
}

variable "location" {
  description = "The location of the Discovery Engine search engine."
  type        = string
  default     = "global"
}

variable "collection_id" {
  description = "The collection ID for the Discovery Engine search engine."
  type        = string
  default     = "default_collection"
}

# ==============================================================================
# Jira Data Connector Specific Variables
# ==============================================================================

variable "jira_collection_display_name" {
  description = "Collection display name for the Jira Data Connector."
  type        = string
  default     = "Kroger Jira Federated Connector"
}

variable "jira_data_source" {
  description = "Data source type for the Jira Data Connector."
  type        = string
  default     = "jira"
}

variable "jira_data_source_version" {
  description = "Data source version for the Jira Data Connector."
  type        = number
  default     = 3
}

variable "jira_instance_uri" {
  description = "Jira instance URI."
  type        = string
}

variable "jira_instance_id" {
  description = "Jira instance ID."
  type        = string
}

variable "jira_client_id" {
  description = "Jira OAuth Client ID."
  type        = string
  sensitive   = true
}

variable "jira_client_secret" {
  description = "Jira OAuth Client Secret."
  type        = string
  sensitive   = true
}

variable "jira_auth_type" {
  description = "Authentication type for Jira connector."
  type        = string
  default     = "OAUTH"
}

variable "jira_refresh_interval" {
  description = "Refresh interval for Jira Data Connector."
  type        = string
  default     = "86400s"
}

variable "jira_destination_key" {
  description = "Destination config key."
  type        = string
  default     = "url"
}

variable "jira_destination_host" {
  description = "Destination host URL."
  type        = string
}

variable "jira_destination_port" {
  description = "Destination port number."
  type        = number
  default     = 0
}

variable "jira_connector_modes" {
  description = "Connector modes for Jira Data Connector."
  type        = list(string)
  default     = ["FEDERATED", "ACTIONS"]
}

variable "jira_sync_mode" {
  description = "Sync mode for Jira Data Connector."
  type        = string
  default     = "PERIODIC"
}

variable "jira_auto_run_disabled" {
  description = "Whether auto run is disabled."
  type        = bool
  default     = true
}

variable "jira_incremental_sync_disabled" {
  description = "Whether incremental sync is disabled."
  type        = bool
  default     = true
}

variable "jira_include_custom_fields" {
  description = "Whether to include custom fields in action params."
  type        = string
  default     = "false"
}

variable "jira_create_bap_connection" {
  description = "Whether to create BAP connection for action config."
  type        = bool
  default     = true
}

variable "jira_bap_supported_connector_modes" {
  description = "Supported connector modes for BAP config."
  type        = list(string)
  default     = ["ACTIONS"]
}

variable "jira_bap_enabled_actions" {
  description = "List of enabled actions for BAP config."
  type        = list(string)
  default     = [
    "create_issue",
    "update_issue",
    "change_issue_status",
    "create_comment",
    "update_comment",
    "upload_attachment",
  ]
}

variable "jira_entities" {
  description = "List of entity names to sync for Jira."
  type        = list(string)
  default     = [
    "project",
    "attachment",
    "comment",
    "issue",
    "bug",
    "epic",
    "story",
    "task",
    "worklog",
    "board",
  ]
}




