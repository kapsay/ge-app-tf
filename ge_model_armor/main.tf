resource "google_model_armor_template" "ge_model_armor_template" {
  provider    = google-beta
  project     = var.project_id
  location    = var.model_armor_location
  template_id = var.model_armor_template_id

  labels = var.model_armor_labels

  filter_config {
    # --------------------------------------------------------------------------
    # Prompt Injection & Jailbreak Detection
    # --------------------------------------------------------------------------
    pi_and_jailbreak_filter_settings {
      filter_enforcement = var.pi_and_jailbreak_filter_settings.filter_enforcement
      confidence_level   = var.pi_and_jailbreak_filter_settings.confidence_level
    }

    # Malicious URI Filtering
    malicious_uri_filter_settings {
      filter_enforcement = var.malicious_uri_filter_settings.filter_enforcement
    }

    # Responsible AI (RAI) Safety Filters
    rai_settings {
      dynamic "rai_filters" {
        for_each = var.rai_filters
        content {
          filter_type      = rai_filters.value.filter_type
          confidence_level = rai_filters.value.confidence_level
        }
      }
    }

    # Sensitive Data Protection (SDP) Basic Config - PII Detection
    sdp_settings {
      basic_config {
        filter_enforcement = var.sdp_basic_config.filter_enforcement
      }
    }
  }

  # Template Metadata & Enforcement Configuration
  template_metadata {
    enforcement_type                   = var.template_metadata.enforcement_type
    log_template_operations            = var.template_metadata.log_template_operations
    log_sanitize_operations            = var.template_metadata.log_sanitize_operations
    custom_prompt_safety_error_code    = var.template_metadata.custom_prompt_safety_error_code
    custom_prompt_safety_error_message = var.template_metadata.custom_prompt_safety_error_message

    multi_language_detection {
      enable_multi_language_detection = var.template_metadata.enable_multi_language_detection
    }
  }
}