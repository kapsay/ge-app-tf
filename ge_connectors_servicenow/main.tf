# ==============================================================================
# Google Discovery Engine Data Connector (ServiceNow with Actions)
# Reference: https://docs.cloud.google.com/gemini/enterprise/docs/connectors/servicenow/set-up-data-store
# ==============================================================================

resource "google_discovery_engine_data_connector" "servicenow-with-actions" {
  location                = var.location
  project                 = var.project_id
  collection_id           = var.collection_id
  collection_display_name = var.servicenow_collection_display_name
  data_source             = var.servicenow_data_source
  data_source_version     = var.servicenow_data_source_version
  kms_key_name            = var.kms_key_name != "" ? var.kms_key_name : null

  params = merge(
    {
      auth_type         = var.servicenow_auth_type
      instance_uri      = var.servicenow_instance_uri
      client_id         = var.servicenow_client_id
      client_secret     = var.servicenow_client_secret
      static_ip_enabled = tostring(var.servicenow_static_ip_enabled)
    },
    var.servicenow_user_account != "" ? { user_account = var.servicenow_user_account } : {},
    var.servicenow_password != "" ? { password = var.servicenow_password } : {},
    var.servicenow_url_suffix != "" ? { url_suffix = var.servicenow_url_suffix } : {},
    var.servicenow_max_qps != "" ? { max_qps = var.servicenow_max_qps } : {},
    var.servicenow_sync_since != "" ? { sync_since = var.servicenow_sync_since } : {},
    var.servicenow_auth_uri != "" ? { auth_uri = var.servicenow_auth_uri } : {},
    var.servicenow_token_uri != "" ? { token_uri = var.servicenow_token_uri } : {}
  )

  refresh_interval             = var.servicenow_refresh_interval
  incremental_refresh_interval = var.servicenow_incremental_refresh_interval
  static_ip_enabled            = var.servicenow_static_ip_enabled

  destination_configs {
    key = var.servicenow_destination_key
    destinations {
      host = var.servicenow_destination_host
      port = var.servicenow_destination_port
    }
  }

  connector_modes           = var.servicenow_connector_modes
  sync_mode                 = var.servicenow_sync_mode
  auto_run_disabled         = var.servicenow_auto_run_disabled
  incremental_sync_disabled = var.servicenow_incremental_sync_disabled

  action_config {
    action_params = merge(
      {
        instance_uri          = var.servicenow_action_instance_uri != "" ? var.servicenow_action_instance_uri : var.servicenow_instance_uri
        client_id             = var.servicenow_action_client_id != "" ? var.servicenow_action_client_id : var.servicenow_client_id
        client_secret         = var.servicenow_action_client_secret != "" ? var.servicenow_action_client_secret : var.servicenow_client_secret
        auth_type             = var.servicenow_action_auth_type
        auth_uri              = var.servicenow_action_auth_uri != "" ? var.servicenow_action_auth_uri : (var.servicenow_auth_uri != "" ? var.servicenow_auth_uri : "${var.servicenow_instance_uri}/oauth_auth.do")
        token_uri             = var.servicenow_action_token_uri != "" ? var.servicenow_action_token_uri : (var.servicenow_token_uri != "" ? var.servicenow_token_uri : "${var.servicenow_instance_uri}/oauth_token.do")
        include_system_tables = tostring(var.servicenow_action_include_system_tables)
      },
      var.servicenow_action_portal_suffix != "" ? { portal_suffix = var.servicenow_action_portal_suffix } : {},
      var.servicenow_action_knowledge_portal_suffix != "" ? { knowledge_portal_suffix = var.servicenow_action_knowledge_portal_suffix } : {},
      var.servicenow_action_catalog_portal_suffix != "" ? { catalog_portal_suffix = var.servicenow_action_catalog_portal_suffix } : {},
      var.servicenow_action_incident_portal_suffix != "" ? { incident_portal_suffix = var.servicenow_action_incident_portal_suffix } : {},
      var.servicenow_action_public_host_url != "" ? { public_host_url = var.servicenow_action_public_host_url } : {}
    )
    create_bap_connection = var.servicenow_create_bap_connection
  }

  bap_config {
    supported_connector_modes = var.servicenow_bap_supported_connector_modes
    enabled_actions           = var.servicenow_bap_enabled_actions
  }

  # Dynamic entities: uses servicenow_entity_configs if specified, else falls back to servicenow_entities list
  dynamic "entities" {
    for_each = length(var.servicenow_entity_configs) > 0 ? var.servicenow_entity_configs : [
      for e in var.servicenow_entities : {
        entity_name           = e
        params                = null
        key_property_mappings = null
      }
    ]
    content {
      entity_name           = entities.value.entity_name
      params                = entities.value.params
      key_property_mappings = entities.value.key_property_mappings
    }
  }

  lifecycle {
    ignore_changes = [
      collection_display_name,
      entities,
      refresh_interval,
      incremental_refresh_interval,
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
