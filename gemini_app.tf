# ==============================================================================
# Gemini Enterprise App (Search Engine) & Assistant Configuration
# ==============================================================================
# Deploys the Gemini Enterprise Intranet Application (Discovery Engine Search Engine),
# configures enterprise features, and provisions the AI Assistant bound to Model Armor.

# ------------------------------------------------------------------------------
# 1. Gemini Enterprise Intranet Search Engine (Application)
# ------------------------------------------------------------------------------
resource "google_discovery_engine_search_engine" "my_demo_app" {
  provider          = google-beta
  project           = var.project_id
  location          = var.location
  collection_id     = var.collection_id
  engine_id         = var.engine_id
  display_name      = var.engine_display_name
  industry_vertical = "GENERIC"
  data_store_ids    = [google_discovery_engine_data_store.my_demo_ds.data_store_id]

  common_config {
    company_name = var.company_name
  }

  search_engine_config {
    search_tier    = "SEARCH_TIER_ENTERPRISE"
    search_add_ons = ["SEARCH_ADD_ON_LLM"]
  }

  /*
  features = {
    # 1. Agent & Prompt Galleries
    "enable-agent-gallery"      = "true"
    "enable-agent-designer"     = "true"
    "enable-prompt-gallery"     = "true"
    "prompt-chips" = "FEATURE_STATE_ON"
    "enable_skills" = "true"

    # 2. End-User Capabilities
    "notebook-lm"               = "true"
    "enable-session-sharing"    = "true"
    "enable-memory"             = "true"

    # 3. Media Generation Tools
    # Note: Depending on the API version, Google sometimes uses 
    # negative keys for these (e.g., disabling the disablement)
    "disable-image-generation"  = "false" 
    "disable-video-generation"  = "false"

    # 4. Data Integrations & Uploads
    "enable-onedrive-upload"     = "true"
    "enable-google-drive-upload" = "true"
    "enable-talk-to-content"     = "true"
    "include-cross-domain-docs"  = "false" # Kept false for security

    # 5. Sharing & Admin Controls
    "enable-agent-sharing"                  = "true"
    "enable-sharing-without-admin-approval" = "false" # Require admin approval
    "enable-welcome-emails"                 = "true"

    # 6. Model Availability & Selectors
    "enable-model-selector"     = "true"
    "enable-gemini-2-5-flash"   = "true"  # Everyday tasks
    "enable-gemini-2-5-pro"     = "true"  # Complex tasks
    "enable-gemini-3-flash"     = "false" # Disabled preview model
    "enable-gemini-3-1-pro"     = "false" # Disabled preview model
  }
  */

  depends_on = [
    google_discovery_engine_data_store.my_demo_ds
  ]
}

# ------------------------------------------------------------------------------
# 2. Gemini Enterprise AI Assistant / Agent with Model Armor Security Binding
# ------------------------------------------------------------------------------
/*
resource "google_discovery_engine_assistant" "my_demo_agent" {
  provider      = google-beta
  project       = var.project_id
  location      = var.location
  collection_id = var.collection_id
  engine_id     = google_discovery_engine_search_engine.my_demo_app.engine_id
  assistant_id  = var.assistant_id
  display_name  = var.assistant_display_name

  customer_policy {
    model_armor_config {
      user_prompt_template = google_model_armor_template.ge_model_armor_template.name
      response_template    = google_model_armor_template.ge_model_armor_template.name
      failure_mode         = "FAIL_CLOSED"
    }
  }

  depends_on = [
    google_discovery_engine_search_engine.my_demo_app,
    google_model_armor_template.ge_model_armor_template
  ]
}
*/
# ------------------------------------------------------------------------------
# 3. Gemini Enterprise Feature Management & Subscription Tier Sync (ADC API Provisioner)
# ------------------------------------------------------------------------------
# Ensures the exact state of enterprise features (Agent Gallery, Agent Designer,
# Prompt Gallery, Model Selector, NotebookLM, Session Sharing, Memory, Canvas,
# Image Generation, Video Generation) and requiredSubscriptionTier are synced with
# the Discovery Engine API using short-lived Application Default Credentials (ADC).
resource "terraform_data" "gemini_feature_management" {
  input = {
    features_json = jsonencode(var.feature_management)
    engine_id     = google_discovery_engine_search_engine.my_demo_app.engine_id
    project_id    = var.project_id
    location      = var.location
  }

  triggers_replace = [
    google_discovery_engine_search_engine.my_demo_app.id,
    jsonencode(var.feature_management)
  ]

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Applying Gemini Enterprise features via ADC for engine: ${google_discovery_engine_search_engine.my_demo_app.engine_id}..."

      # 1. Acquire token dynamically via ADC (Zero state file exposure)
      TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null || \
        python3 -c "import google.auth, google.auth.transport.requests; c, _ = google.auth.default(); c.refresh(google.auth.transport.requests.Request()); print(c.token)" 2>/dev/null || \
        curl -s -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" | jq -r ".access_token // empty" 2>/dev/null || \
        gcloud auth print-access-token 2>/dev/null)

      if [ -z "$TOKEN" ]; then
        echo "ERROR: Failed to acquire Google Cloud ADC token." >&2
        exit 1
      fi

      ENDPOINT="https://${var.location == "global" ? "" : "${var.location}-"}discoveryengine.googleapis.com/v1/projects/${var.project_id}/locations/${var.location}/collections/${var.collection_id}/engines/${google_discovery_engine_search_engine.my_demo_app.engine_id}"

      RESPONSE=$(curl -s -w "\n%%{http_code}" -X PATCH \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -H "X-Goog-User-Project: ${var.project_id}" \
        "$ENDPOINT?updateMask=features" \
        -d '${jsonencode({
    features = var.feature_management
})}')

      HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
      BODY=$(echo "$RESPONSE" | sed '$d')

      if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
        echo "Successfully synced Gemini Enterprise features (HTTP $HTTP_STATUS)."
      else
        echo "ERROR: Failed to sync features (HTTP $HTTP_STATUS): $BODY" >&2
        exit 1
      fi
    EOT
}

depends_on = [
  google_discovery_engine_search_engine.my_demo_app
]
}
