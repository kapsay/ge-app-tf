# ==============================================================================
# Model Armor Template Configuration
# ==============================================================================
# Deploys a Google Cloud Model Armor template to screen incoming user prompts
# and outgoing LLM responses for safety, security, prompt injection, and PII leaks.

resource "google_model_armor_template" "ge_model_armor_template" {
  provider    = google-beta
  project     = var.project_id
  location    = var.model_armor_location
  template_id = "ge-model-armor-template"

  labels = {
    environment = "production"
    managed_by  = "terraform"
    application = "gemini-enterprise"
  }

  filter_config {
    # --------------------------------------------------------------------------
    # Prompt Injection & Jailbreak Detection
    # --------------------------------------------------------------------------
    pi_and_jailbreak_filter_settings {
      filter_enforcement = "ENABLED"
      confidence_level   = "MEDIUM_AND_ABOVE"
    }

    # Malicious URI Filtering
    malicious_uri_filter_settings {
      filter_enforcement = "ENABLED"
    }

    # Responsible AI (RAI) Safety Filters
    rai_settings {
      rai_filters {
        filter_type      = "HATE_SPEECH"
        confidence_level = "MEDIUM_AND_ABOVE"
      }
      rai_filters {
        filter_type      = "HARASSMENT"
        confidence_level = "MEDIUM_AND_ABOVE"
      }
      rai_filters {
        filter_type      = "SEXUALLY_EXPLICIT"
        confidence_level = "MEDIUM_AND_ABOVE"
      }
      rai_filters {
        filter_type      = "DANGEROUS"
        confidence_level = "MEDIUM_AND_ABOVE"
      }
    }

    # Sensitive Data Protection (SDP) Basic Config - PII Detection
    sdp_settings {
      basic_config {
        filter_enforcement = "ENABLED"
      }
    }
  }

  # Template Metadata & Enforcement Configuration
  template_metadata {
    enforcement_type                   = "INSPECT_AND_BLOCK"
    log_template_operations            = true
    log_sanitize_operations            = true
    custom_prompt_safety_error_code    = 400
    custom_prompt_safety_error_message = "Request or response violated enterprise security and safety screening policies."

    multi_language_detection {
      enable_multi_language_detection = true
    }

    filter_version_selector {
      alias = "FILTER_VERSION_ALIAS_LATEST"
    }
  }
}