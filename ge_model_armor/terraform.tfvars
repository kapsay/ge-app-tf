# ==============================================================================
# Terraform Variable Values
# ==============================================================================

project_id        = "ai-work-445217"

# Model Armor Configuration
model_armor_location    = "us-central1"
model_armor_template_id = "ge-model-armor-template"

model_armor_labels = {
  environment = "production"
  managed_by  = "terraform"
  application = "gemini-enterprise"
}

pi_and_jailbreak_filter_settings = {
  filter_enforcement = "ENABLED"
  confidence_level   = "MEDIUM_AND_ABOVE"
}

malicious_uri_filter_settings = {
  filter_enforcement = "ENABLED"
}

rai_filters = [
  {
    filter_type      = "HATE_SPEECH"
    confidence_level = "MEDIUM_AND_ABOVE"
  },
  {
    filter_type      = "HARASSMENT"
    confidence_level = "MEDIUM_AND_ABOVE"
  },
  {
    filter_type      = "SEXUALLY_EXPLICIT"
    confidence_level = "MEDIUM_AND_ABOVE"
  },
  {
    filter_type      = "DANGEROUS"
    confidence_level = "MEDIUM_AND_ABOVE"
  }
]

sdp_basic_config = {
  filter_enforcement = "ENABLED"
}

template_metadata = {
  enforcement_type                   = "INSPECT_AND_BLOCK"
  log_template_operations            = true
  log_sanitize_operations            = true
  custom_prompt_safety_error_code    = 400
  custom_prompt_safety_error_message = "Request or response violated enterprise security and safety screening policies."
  enable_multi_language_detection    = true
}




