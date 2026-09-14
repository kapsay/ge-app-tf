# ==============================================================================
# Google Discovery Engine Search Engine Variables
# ==============================================================================

variable "project_id" {
  description = "The GCP Project ID where the Discovery Engine search engine will be created."
  type        = string
}

variable "project_num" {
  description = "The GCP Project number where the Discovery Engine search engine will be created."
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

variable "engine_id" {
  description = "The ID of the search engine."
  type        = string
}

variable "display_name" {
  description = "The display name of the search engine."
  type        = string
}

variable "app_type" {
  description = "The type of the app (e.g., APP_TYPE_INTRANET)."
  type        = string
  default     = "APP_TYPE_INTRANET"
}

variable "industry_vertical" {
  description = "The industry vertical for the search engine."
  type        = string
  default     = "GENERIC"
}

variable "deletion_policy" {
  description = "The deletion policy for the search engine."
  type        = string
  default     = "DELETE"
}

variable "disable_analytics" {
  description = "Whether to disable analytics for the search engine."
  type        = bool
  default     = false
}

variable "data_store_ids" {
  description = "List of data store IDs associated with the search engine."
  type        = list(string)
  default     = []
}

variable "features" {
  description = "Map of feature states for the search engine."
  type        = map(string)
  default     = {}
}

variable "company_name" {
  description = "Company name for the common configuration."
  type        = string
}

variable "knowledge_graph_config" {
  description = "Knowledge graph configuration for the search engine."
  type = object({
    cloud_knowledge_graph_types    = list(string)
    enable_cloud_knowledge_graph   = bool
    enable_private_knowledge_graph = bool
  })
  default = {
    cloud_knowledge_graph_types    = []
    enable_cloud_knowledge_graph   = false
    enable_private_knowledge_graph = true
  }
}

variable "search_engine_config" {
  description = "Search engine specific configuration."
  type = object({
    required_subscription_tier = string
    search_add_ons             = list(string)
    search_tier                = string
  })
  default = {
    required_subscription_tier = "SUBSCRIPTION_TIER_SEARCH_AND_ASSISTANT"
    search_add_ons             = ["SEARCH_ADD_ON_LLM"]
    search_tier                = "SEARCH_TIER_ENTERPRISE"
  }
}

# ==============================================================================
# BigQuery Data Store Variables (ge_dc_bq)
# ==============================================================================

variable "bq_data_store_id" {
  description = "The ID of the BigQuery data store."
  type        = string
  default     = "ecomm-events_1780862168950"
}

variable "bq_data_store_display_name" {
  description = "The display name of the BigQuery data store."
  type        = string
  default     = "ecomm_events"
}

variable "bq_data_store_industry_vertical" {
  description = "The industry vertical for the BigQuery data store."
  type        = string
  default     = "GENERIC"
}

variable "bq_data_store_solution_types" {
  description = "Solution types for the BigQuery data store."
  type        = list(string)
  default     = ["SOLUTION_TYPE_SEARCH"]
}

variable "bq_data_store_acl_enabled" {
  description = "Whether ACL is enabled for the BigQuery data store."
  type        = bool
  default     = false
}

variable "bq_data_store_deletion_policy" {
  description = "Deletion policy for the BigQuery data store."
  type        = string
  default     = "DELETE"
}

variable "bq_data_store_default_schema_id" {
  description = "Default schema ID for the BigQuery data store."
  type        = string
  default     = "default_schema"
}

variable "bq_data_store_layout_parsing_config" {
  description = "Layout parsing configuration for the BigQuery data store."
  type = object({
    enable_get_processed_document = bool
    enable_image_annotation       = bool
    enable_llm_layout_parsing     = bool
    enable_table_annotation       = bool
  })
  default = {
    enable_get_processed_document = false
    enable_image_annotation       = false
    enable_llm_layout_parsing     = false
    enable_table_annotation       = false
  }
}

# ==============================================================================
# MCP Data Store Variables (ge_dc_mcp)
# ==============================================================================

variable "mcp_data_store_id" {
  description = "The ID of the MCP data store."
  type        = string
  default     = "developer-docs_1784867512211_mcp_data"
}

variable "mcp_data_store_display_name" {
  description = "The display name of the MCP data store."
  type        = string
  default     = "mcp_data"
}

variable "mcp_data_store_industry_vertical" {
  description = "The industry vertical for the MCP data store."
  type        = string
  default     = "GENERIC"
}

variable "mcp_data_store_solution_types" {
  description = "Solution types for the MCP data store."
  type        = list(string)
  default     = ["SOLUTION_TYPE_SEARCH"]
}

variable "mcp_data_store_acl_enabled" {
  description = "Whether ACL is enabled for the MCP data store."
  type        = bool
  default     = false
}

variable "mcp_data_store_deletion_policy" {
  description = "Deletion policy for the MCP data store."
  type        = string
  default     = "DELETE"
}

variable "mcp_data_store_default_schema_id" {
  description = "Default schema ID for the MCP data store."
  type        = string
  default     = "default_schema"
}

# ==============================================================================
# Data Connector Variables (ge_dc_jira_etc)
# ==============================================================================

variable "dc_collection_id" {
  description = "Collection ID for the Discovery Engine data connector."
  type        = string
  default     = "kroger_demo_data_connector"
}

variable "dc_collection_display_name" {
  description = "Collection display name for the Discovery Engine data connector."
  type        = string
  default     = "kroger_demo_data_connector display name"
}

variable "dc_connector_modes" {
  description = "Connector modes for the Discovery Engine data connector."
  type        = list(string)
  default     = ["FEDERATED"]
}

variable "dc_connector_type" {
  description = "Connector type for the Discovery Engine data connector."
  type        = string
  default     = "THIRD_PARTY_FEDERATED"
}

variable "dc_data_source" {
  description = "Data source type for the Discovery Engine data connector."
  type        = string
  default     = "custom_mcp"
}

variable "dc_deletion_policy" {
  description = "Deletion policy for the Discovery Engine data connector."
  type        = string
  default     = "DELETE"
}

variable "dc_refresh_interval" {
  description = "Refresh interval for the Discovery Engine data connector."
  type        = string
  default     = "86400s"
}

variable "dc_static_ip_enabled" {
  description = "Whether static IP is enabled for the Discovery Engine data connector."
  type        = bool
  default     = false
}

variable "dc_action_config" {
  description = "Action config for the Discovery Engine data connector."
  type = object({
    action_params         = map(string)
    create_bap_connection = bool
    is_action_configured  = bool
  })
  default = {
    action_params         = {}
    create_bap_connection = false
    is_action_configured  = false
  }
}

variable "dc_bap_config" {
  description = "BAP config for the Discovery Engine data connector."
  type = object({
    enabled_actions           = list(string)
    supported_connector_modes = list(string)
  })
  default = {
    enabled_actions           = ["answer_query", "get_documents", "search_documents"]
    supported_connector_modes = []
  }
}

variable "dc_entity_data_store" {
  description = "Data store path for the data connector entity."
  type        = string
  default     = "projects/545804763087/locations/global/collections/default_collection/dataStores/developer-docs_1784867512211_mcp_data"
}

variable "dc_entity_name" {
  description = "Entity name for the data connector entity."
  type        = string
  default     = "mcp_data"
}

variable "dc_key_property_mappings" {
  description = "Key property mappings for the data connector entity."
  type        = map(string)
  default     = {}
}



