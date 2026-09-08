# Google Cloud Gemini Enterprise App - Terraform Configuration

This repository provides production-ready, modular Terraform configurations to deploy and configure a **Google Cloud Gemini Enterprise Application** (powered by Vertex AI Search and Conversation / Discovery Engine), an associated **Data Store**, an **AI Assistant / Agent**, proactive **Model Armor security screening**, comprehensive **Feature Management**, and end-to-end **Observability**.

---

## Architecture Overview

```
                                      +---------------------------------------------+
                                      |            Gemini Enterprise App            |
                                      | (google_discovery_engine_search_engine)     |
                                      |  - APP_TYPE_INTRANET                        |
                                      |  - Features: Agent Gallery, Canvas, etc.    |
                                      +----------------------+----------------------+
                                                             |
                              +------------------------------+------------------------------+
                              |                                                             |
                              v                                                             v
        +-----------------------------------+                     +-----------------------------------+
        |       Discovery Data Store        |                     |       Model Armor Template        |
        | (google_discovery_engine_data_store)                    |  (google_model_armor_template)    |
        |  - SOLUTION_TYPE_CHAT             |                     |   - PI & Jailbreak Filter         |
        +-----------------------------------+                     |   - Malicious URI Filter          |
                                                                  |   - Responsible AI (RAI) Filters  |
                                                                  |   - Sensitive Data Protection SDP |
                                                                  |   - Mode: INSPECT_AND_BLOCK       |
                                                                  +-----------------------------------+
                                                                                    |
                                                                                    v
+---------------------------------------------------------------------------------------------------+
|                                  Observability & Telemetry Stack                                  |
|  - Discovery Engine & Model Armor Service Agents                                                  |
|  - OpenTelemetry Tracing to Cloud Trace (roles/cloudtrace.agent)                                  |
|  - Telemetry Metrics to Cloud Monitoring (roles/monitoring.metricWriter)                          |
|  - Cloud Logging Project Sink (google_logging_project_sink) -> BigQuery Audit Dataset             |
+---------------------------------------------------------------------------------------------------+
```

---

## File Structure

| File | Purpose |
| :--- | :--- |
| [`providers.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/providers.tf) | Configures `hashicorp/google` and `hashicorp/google-beta` providers. |
| [`variables.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/variables.tf) | Defines configurable variables for projects, regions, app settings, features, and logs. |
| [`model_armor.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/model_armor.tf) | Provisions the `google_model_armor_template` with safety, prompt injection, and PII filters. |
| [`data_store.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/data_store.tf) | Provisions `google_discovery_engine_data_store` with `SOLUTION_TYPE_CHAT`. |
| [`gemini_app.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/gemini_app.tf) | Deploys Intranet Search Engine, AI Assistant bound to Model Armor, and feature toggles. |
| [`observability.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/observability.tf) | Configures OpenTelemetry, Cloud Trace, IAM roles, BigQuery audit dataset, and Logging sink. |
| [`outputs.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/outputs.tf) | Exposes resource IDs, names, service account emails, and BigQuery log sink details. |
| [`terraform.tfvars.example`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/terraform.tfvars.example) | Template variable file for quick environment customization. |

---

## Key Configurations & Features

### 1. Model Armor Security Screening
- **Prompt Injection & Jailbreak:** Screened with `filter_enforcement = "ENABLED"` and confidence `MEDIUM_AND_ABOVE`.
- **Malicious URI Filter:** Blocks known malicious links embedded in prompts or generated outputs.
- **Responsible AI (RAI):** Full coverage across `HATE_SPEECH`, `HARASSMENT`, `SEXUALLY_EXPLICIT`, and `DANGEROUS`.
- **Sensitive Data Protection (SDP):** Built-in basic config filter enforcement for PII detection.
- **Enforcement Mode:** `INSPECT_AND_BLOCK` ensures requests violating policy are dropped.
- **Sanitize Logging:** Operations and template events logged for compliance auditability.

### 2. Gemini Enterprise Features Toggled
- **Agent Gallery:** Centralized directory of enterprise and partner agents.
- **Agent Designer:** Interactive no-code/low-code agent builder.
- **Prompt Gallery:** Reusable prompt libraries.
- **Model Selector:** Dynamic selection of underlying Gemini models.
- **NotebookLM:** Deep grounded research and document-level note-taking.
- **Session Sharing:** Share conversational sessions across enterprise teams.
- **Personalization / Memory:** Context retention across conversations.
- **Canvas:** Side-by-side generative document creation and editing.
- **Image Generation:** AI media generation capabilities.
- **Video Generation:** AI video generation capabilities.

### 3. Observability & Logging
- **OpenTelemetry & Cloud Trace:** Automatic distributed trace context propagation with `roles/cloudtrace.agent`.
- **Cloud Monitoring:** Custom latency, request volume, and safety block monitoring dashboard.
- **Audit Logging Sink:** Captures raw Discovery Engine API payloads and Model Armor screening logs into a partitioned BigQuery dataset with retention policies.

---

## Prerequisites

Ensure the following Google Cloud APIs are enabled on your project:

```bash
gcloud services enable \
  discoveryengine.googleapis.com \
  modelarmor.googleapis.com \
  logging.googleapis.com \
  cloudtrace.googleapis.com \
  monitoring.googleapis.com \
  bigquery.googleapis.com
```

---

## Deployment Instructions

1. **Prepare Variable File:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Edit `terraform.tfvars` with your `project_id`.

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Review the Execution Plan:**
   ```bash
   terraform plan
   ```

4. **Deploy the Infrastructure:**
   ```bash
   terraform apply
   ```
