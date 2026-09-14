resource "google_discovery_engine_data_connector" "jira-with-actions" {
  location                  = var.location
  project                   = var.project_id
  collection_id             = var.collection_id
  collection_display_name   = var.jira_collection_display_name
  data_source               = var.jira_data_source
  data_source_version       = var.jira_data_source_version
  params = {
    instance_uri  = var.jira_instance_uri
    instance_id   = var.jira_instance_id
    client_id     = var.jira_client_id
    client_secret = var.jira_client_secret
    # refresh_token              = "SECRET_MANAGER_RESOURCE_NAME"
    auth_type     = var.jira_auth_type
  }
  refresh_interval          = var.jira_refresh_interval

  destination_configs {
    key = var.jira_destination_key
    destinations {
      host = var.jira_destination_host
      port = var.jira_destination_port
    }
  }
  connector_modes           = var.jira_connector_modes
  sync_mode                 = var.jira_sync_mode
  auto_run_disabled         = var.jira_auto_run_disabled
  incremental_sync_disabled = var.jira_incremental_sync_disabled
  action_config {
    action_params = {
      instance_uri          = var.jira_instance_uri
      instance_id           = var.jira_instance_id
      client_id             = var.jira_client_id
      client_secret         = var.jira_client_secret
      auth_type             = var.jira_auth_type
      include_custom_fields = var.jira_include_custom_fields
    }
    create_bap_connection   = var.jira_create_bap_connection
  }

  bap_config {
    supported_connector_modes = var.jira_bap_supported_connector_modes
    enabled_actions           = var.jira_bap_enabled_actions
  }

  dynamic "entities" {
    for_each = var.jira_entities
    content {
      entity_name = entities.value
    }
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