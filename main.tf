# ==============================================================================
# Google Cloud Discovery Engine - Jira Data Connector Configuration
# ==============================================================================
# Provisions and manages the Atlassian Jira federated data connector and action
# connector within Google Discovery Engine / Gemini Enterprise.
#
# Automatically loads Jira credentials from the local `.env` file if present,
# with fallback to Terraform input variables.
# ==============================================================================

locals {
  # ----------------------------------------------------------------------------
  # 1. Automatic .env Configuration Parsing
  # ----------------------------------------------------------------------------
  env_file_exists = fileexists("${path.module}/.env")
  env_lines = local.env_file_exists ? [
    for line in split("\n", file("${path.module}/.env")) :
    trimspace(line) if trimspace(line) != "" && !startswith(trimspace(line), "#")
  ] : []
  env_vars = {
    for line in local.env_lines :
    trimspace(split("=", line)[0]) => trimspace(join("=", slice(split("=", line), 1, length(split("=", line)))))
    if length(split("=", line)) >= 2
  }

  # Resolution hierarchy: .env file -> Terraform variables -> defaults
  jira_client_raw = try(local.env_vars["JIRA_CLIENT"], var.jira_client)
  jira_secret_raw = try(local.env_vars["JIRA_SECRET"], var.jira_secret)
  jira_site_raw   = try(local.env_vars["JIRA_SITE"], var.jira_site)
  jira_cloud_raw  = try(local.env_vars["JIRA_CLOUD_ID"], var.jira_cloud_id)

  # Normalize Jira URL (ensures https:// prefix and strips trailing slash)
  jira_site_clean = trimsuffix(
    startswith(local.jira_site_raw, "http://") || startswith(local.jira_site_raw, "https://") ?
    local.jira_site_raw : "https://${local.jira_site_raw}",
    "/"
  )

  # Normalize Jira Instance ID / URI format
  jira_instance_id = local.jira_cloud_raw != "" ? local.jira_cloud_raw : "${local.jira_site_clean}/"
}

# ------------------------------------------------------------------------------
# 2. Jira Federated & Action Data Connector
# ------------------------------------------------------------------------------
resource "google_discovery_engine_data_connector" "jira_federated" {
  provider = google

  project                 = var.project_id
  location                = var.location
  collection_id           = var.jira_collection_id
  collection_display_name = var.jira_collection_display_name

  data_source               = "jira"
  refresh_interval          = var.jira_refresh_interval
  connector_modes           = ["FEDERATED", "ACTIONS"]
  sync_mode                 = "PERIODIC"
  auto_run_disabled         = true
  incremental_sync_disabled = true

  params = {
    instance_uri  = local.jira_site_clean
    instance_id   = local.jira_instance_id
    client_id     = local.jira_client_raw
    client_secret = local.jira_secret_raw
    auth_type     = "OAUTH"
  }

  destination_configs {
    key = "url"
    destinations {
      host = local.jira_site_clean
      port = 0
    }
  }

  action_config {
    action_params = {
      auth_type             = "OAUTH"
      instance_uri          = local.jira_site_clean
      include_custom_fields = "false"
    }
    create_bap_connection = false
  }

  bap_config {
    supported_connector_modes = ["ACTIONS"]
    enabled_actions = [
      "create_issue",
      "update_issue",
      "change_issue_status",
      "create_comment",
      "update_comment",
      "upload_attachment",
    ]
  }

  # Jira connector entities provisioned in Discovery Engine
  entities {
    entity_name = "project"
  }
  entities {
    entity_name = "attachment"
  }
  entities {
    entity_name = "comment"
  }
  entities {
    entity_name = "issue"
  }
  entities {
    entity_name = "bug"
  }
  entities {
    entity_name = "epic"
  }
  entities {
    entity_name = "story"
  }
  entities {
    entity_name = "task"
  }
  entities {
    entity_name = "worklog"
  }
  entities {
    entity_name = "board"
  }

  lifecycle {
    ignore_changes = [
      collection_display_name,
      entities,
      refresh_interval,
      params,
      action_config,
      destination_configs,
      bap_config,
      static_ip_enabled,
      connector_modes,
      auto_run_disabled,
      incremental_sync_disabled,
      sync_mode,
    ]
  }
}
