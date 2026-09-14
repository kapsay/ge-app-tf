# ==============================================================================
# Google Discovery Engine Search Engine Variables
# ==============================================================================

variable "project_id" {
  description = "The GCP Project ID where the Discovery Engine search engine will be created."
  type        = string
}

# ==============================================================================
# Model Armor Template Variables
# ==============================================================================

variable "model_armor_location" {
  description = "The GCP location/region for the Model Armor template."
  type        = string
  default     = "us-central1"
}

variable "model_armor_template_id" {
  description = "The template ID for the Model Armor template."
  type        = string
  default     = "ge-model-armor-template"
}

variable "model_armor_labels" {
  description = "Labels to apply to the Model Armor template."
  type        = map(string)
  default = {
    environment = "production"
    managed_by  = "terraform"
    application = "gemini-enterprise"
  }
}

variable "pi_and_jailbreak_filter_settings" {
  description = "Prompt Injection & Jailbreak Detection filter settings."
  type = object({
    filter_enforcement = string
    confidence_level   = string
  })
  default = {
    filter_enforcement = "ENABLED"
    confidence_level   = "MEDIUM_AND_ABOVE"
  }
}

variable "malicious_uri_filter_settings" {
  description = "Malicious URI filter settings."
  type = object({
    filter_enforcement = string
  })
  default = {
    filter_enforcement = "ENABLED"
  }
}

variable "rai_filters" {
  description = "List of Responsible AI (RAI) safety filters and confidence levels."
  type = list(object({
    filter_type      = string
    confidence_level = string
  }))
  default = [
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
}

variable "sdp_basic_config" {
  description = "Sensitive Data Protection (SDP) basic config settings."
  type = object({
    filter_enforcement = string
  })
  default = {
    filter_enforcement = "ENABLED"
  }
}

variable "template_metadata" {
  description = "Template metadata and enforcement configuration."
  type = object({
    enforcement_type                   = string
    log_template_operations            = bool
    log_sanitize_operations            = bool
    custom_prompt_safety_error_code    = number
    custom_prompt_safety_error_message = string
    enable_multi_language_detection    = bool
  })
  default = {
    enforcement_type                   = "INSPECT_AND_BLOCK"
    log_template_operations            = true
    log_sanitize_operations            = true
    custom_prompt_safety_error_code    = 400
    custom_prompt_safety_error_message = "Request or response violated enterprise security and safety screening policies."
    enable_multi_language_detection    = true
  }
}




