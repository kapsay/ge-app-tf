# ==============================================================================
# Terraform Variable Values
# ==============================================================================

project_id        = "<Your Project ID>"
location          = "global"
collection_id     = "kroger_collection"

# Jira Data Connector (jira-with-actions)
jira_collection_display_name = "Kroger Jira Federated Connector"
jira_data_source             = "jira"
jira_data_source_version     = 3
jira_instance_uri            = "<Your URI>"
jira_instance_id             = "<Your Instance ID>"
jira_client_id               = "<Your Client ID>"
jira_client_secret           = "<Your Client Secret>"
jira_auth_type               = "OAUTH"
jira_refresh_interval        = "86400s"
jira_destination_key         = "url"
jira_destination_host        = "<Your URI>"
jira_destination_port        = 0
jira_connector_modes         = ["FEDERATED", "ACTIONS"]
jira_sync_mode               = "PERIODIC"
jira_auto_run_disabled       = true
jira_incremental_sync_disabled = true
jira_include_custom_fields   = "false"
jira_create_bap_connection   = true
jira_bap_supported_connector_modes = ["ACTIONS"]
jira_bap_enabled_actions = [
  "create_issue",
  "update_issue",
  "change_issue_status",
  "create_comment",
  "update_comment",
  "upload_attachment",
]
jira_entities = [
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