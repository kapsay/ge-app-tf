Act as a Google Cloud Principal Cloud Architect and Terraform expert.

Generate a complete, modular, and production-ready Terraform configuration to deploy and configure a Google Cloud Gemini Enterprise App, associated Data Store, AI Agent, Model Armor security screening, feature management, and end-to-end observability.

### Requirements:

1. Provider & Project Setup:
   - Configure Google (`hashicorp/google`) and Google-Beta (`hashicorp/google-beta`) providers.
   - Use configurable variables for `project_id`, `region` (default: "us"), and `location` (default: "global").

2. Model Armor Template:
   - Resource: `google_model_armor_template` named "ge_model_armor_template".
   - Configure screening for:
     * Prompt Injection & Jailbreak detection (`pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"`).
     * Malicious URI filtering (`enable_malicious_uri_filter_settings = true`).
     * Responsible AI (RAI) filters (`hate_speech`, `harassment`, `sexually_explicit`, `dangerous_content`).
     * Sensitive Data Protection (SDP) basic config filter enforcement for PII detection.
     * Enforcement type set to `INSPECT_AND_BLOCK`.
     * Logging of sanitize operations enabled.

3. Data Store:
   - Resource: `google_discovery_engine_data_store` with `data_store_id = "my_demo_ds"`, `display_name = "My Demo Data Store"`, `industry_vertical = "GENERIC"`, `content_config = "NO_CONTENT"` (or structured/unstructured), and solution type `SOLUTION_TYPE_CHAT`.

4. Gemini Enterprise App (Engine):
   - Resource: `google_discovery_engine_search_engine` with `engine_id = "my_demo_app"`, `display_name = "My Demo Gemini Enterprise App"`, `collection_id = "default_collection"`, `app_type = "APP_TYPE_INTRANET"`, `industry_vertical = "GENERIC"`.
   - Attach `data_store_ids = [google_discovery_engine_data_store.my_demo_ds.data_store_id]`.
   - Configure feature management map to toggle GE features: Agent Gallery, Agent Designer, Prompt Gallery, Model Selector, NotebookLM, Session Sharing, Memory/Customization, Canvas, Image Generation, and Video Generation.

5. Agent / Assistant & Model Armor Binding:
   - Resource: `google_discovery_engine_assistant` with `assistant_id = "my_demo_agent"`, `display_name = "My Demo Agent"`, linked to `engine_id = google_discovery_engine_search_engine.my_demo_app.engine_id`.
   - Bind the Model Armor template using `model_armor_config` for both `user_prompt_template` and `response_template` with `failure_mode = "FAIL_CLOSED"`.

6. Observability & Logging:
   - Enable OpenTelemetry traces, spans, and metrics instrumentation to Cloud Trace and Cloud Monitoring.
   - Enable full logging of prompt inputs and response outputs via a dedicated Cloud Logging sink (`google_logging_project_sink`) capturing Discovery Engine payloads to a secure BigQuery dataset or Cloud Storage bucket.
   - Grant necessary IAM permissions to Discovery Engine and Model Armor service agents (`roles/modelarmor.user`, `roles/logging.logWriter`, `roles/cloudtrace.agent`).

Please output clean, modular HCL files: `providers.tf`, `variables.tf`, `model_armor.tf`, `data_store.tf`, `gemini_app.tf`, `observability.tf`, and `outputs.tf`.
