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