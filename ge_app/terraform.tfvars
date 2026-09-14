# ==============================================================================
# Terraform Variable Values
# ==============================================================================

project_id        = "<Your Project ID>"
project_num       = "<Your Project Number>"
location          = "global"
collection_id     = "kroger_collection"
engine_id         = "kroger_demo_app_tf"
display_name      = "Kroger Demo App via Terraform"
app_type          = "APP_TYPE_INTRANET"
industry_vertical = "GENERIC"
deletion_policy   = "DELETE"
disable_analytics = false
company_name      = "The Kroger Co."

data_store_ids = [
  "<Your Data Store ID - 1>",
  "<Your Data Store ID - 2>", 
]

features = {
  "agent-gallery"                        = "FEATURE_STATE_ON"
  "agent-sharing-without-admin-approval" = "FEATURE_STATE_OFF"
  "bi-directional-audio"                 = "FEATURE_STATE_OFF"
  "cross-product-intelligence"           = "FEATURE_STATE_OFF"
  "disable-agent-sharing"                = "FEATURE_STATE_OFF"
  "disable-canvas"                       = "FEATURE_STATE_OFF"
  "disable-canvas-workspace"             = "FEATURE_STATE_OFF"
  "disable-google-drive-upload"          = "FEATURE_STATE_OFF"
  "disable-image-generation"             = "FEATURE_STATE_OFF"
  "disable-mobile-app-access"            = "FEATURE_STATE_OFF"
  "disable-onedrive-upload"              = "FEATURE_STATE_OFF"
  "disable-skills"                       = "FEATURE_STATE_OFF"
  "disable-talk-to-content"              = "FEATURE_STATE_OFF"
  "disable-video-generation"             = "FEATURE_STATE_OFF"
  "disable-welcome-emails"               = "FEATURE_STATE_OFF"
  "enable-end-user-sharing-with-groups"  = "FEATURE_STATE_OFF"
  "in-app-notifications"                 = "FEATURE_STATE_OFF"
  "model-selector"                       = "FEATURE_STATE_ON"
  "no-code-agent-builder"                = "FEATURE_STATE_ON"
  "notebook-lm"                          = "FEATURE_STATE_ON"
  "people-search-org-chart"              = "FEATURE_STATE_ON"
  "personalization-memory"               = "FEATURE_STATE_ON"
  "personalization-suggested-highlights" = "FEATURE_STATE_ON"
  "prompt-gallery"                       = "FEATURE_STATE_ON"
  "session-sharing"                      = "FEATURE_STATE_OFF"
}

knowledge_graph_config = {
  cloud_knowledge_graph_types    = []
  enable_cloud_knowledge_graph   = false
  enable_private_knowledge_graph = true
}

search_engine_config = {
  required_subscription_tier = "SUBSCRIPTION_TIER_SEARCH_AND_ASSISTANT"
  search_add_ons             = ["SEARCH_ADD_ON_LLM"]
  search_tier                = "SEARCH_TIER_ENTERPRISE"
}