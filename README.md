# Google Cloud Gemini Enterprise App - Terraform Architecture & Management

This repository provides modular, production-ready Terraform configurations to deploy and manage a **Google Cloud Gemini Enterprise Application** (powered by Vertex AI Search & Conversation / Discovery Engine API), an associated **Data Store**, enterprise **Feature Management** with Application Default Credentials (ADC), proactive **Model Armor security screening**, and end-to-end **Observability and Audit Logging**.

---

## Architecture Overview

```
                                      +---------------------------------------------+
                                      |            Gemini Enterprise App            |
                                      | (google_discovery_engine_search_engine)     |
                                      |  - Engine ID: terraform-instance-ge         |
                                      |  - Common Config (Company Name)             |
                                      |  - Search Tier Enterprise & LLM Add-on      |
                                      +----------------------+----------------------+
                                                             |
                             +-------------------------------+-------------------------------+
                             |                                                               |
                             v                                                               v
       +-----------------------------------+                       +-----------------------------------+
       |       Discovery Data Store        |                       |       Model Armor Template        |
       | (google_discovery_engine_data_store)                      |    (google_model_armor_template)  |
       |  - Solution: SEARCH               |                       |   - PI & Jailbreak Filter         |
       |  - Lifecycle: ignore drift        |                       |   - Malicious URI Filter          |
       +-----------------------------------+                       |   - Responsible AI (RAI) Filters  |
                                                                   |   - Sensitive Data Protection SDP |
                                                                   |   - Mode: INSPECT_AND_BLOCK       |
                                                                   +-----------------------------------+
                                                                                     |
                             +-------------------------------------------------------+
                             |
                             v
+---------------------------------------------------------------------------------------------------+
|                            Gemini Enterprise Feature Management (ADC)                             |
| (terraform_data.gemini_feature_management)                                                        |
|  - Dynamic Application Default Credentials (ADC) Token Resolution                                 |
|  - Zero Secret Exposure: Bearer tokens never touch .tfstate or Secret Manager                     |
|  - Real-time Sync of Enterprise Feature Flags:                                                    |
|    * agent-gallery          * agent-designer           * prompt-gallery                           |
|    * model-selector         * notebook-lm              * session-sharing                          |
|    * personalization-memory * canvas                   * image-generation                         |
|    * video-generation                                                                             |
+---------------------------------------------------------------------------------------------------+
                                                             |
                                                             v
+---------------------------------------------------------------------------------------------------+
|                                  Observability & Telemetry Stack                                  |
|  - Discovery Engine & Model Armor Service Agents (google_project_service_identity)                |
|  - OpenTelemetry Tracing to Cloud Trace (roles/cloudtrace.agent)                                  |
|  - Telemetry Metrics to Cloud Monitoring (roles/monitoring.metricWriter)                          |
|  - Custom Cloud Monitoring Dashboard (Latency, API consumption, Security Blocks)                 |
|  - Cloud Logging Sink (google_logging_project_sink) -> Partitioned BigQuery Audit Dataset         |
+---------------------------------------------------------------------------------------------------+
```

---

## File Structure

| File | Purpose |
| :--- | :--- |
| [`main.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/main.tf) | Provisions `google_discovery_engine_data_connector` for Atlassian Jira with automatic `.env` credential loading. |
| [`providers.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/providers.tf) | Configures `hashicorp/google` and `hashicorp/google-beta` providers. |
| [`variables.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/variables.tf) | Defines configurable variables for projects, regions, app settings, Jira connector, feature flags, and logs. |
| [`gemini_app.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/gemini_app.tf) | Deploys Discovery Engine Search Engine and ADC-based dynamic feature management (`terraform_data`). |
| [`data_store.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/data_store.tf) | Provisions `google_discovery_engine_data_store` with drift-protected lifecycle rules. |
| [`model_armor.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/model_armor.tf) | Provisions the `google_model_armor_template` with safety, prompt injection, and PII filters. |
| [`observability.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/observability.tf) | Configures OpenTelemetry, Cloud Trace, IAM roles, BigQuery audit dataset, and Logging sink. |
| [`outputs.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/outputs.tf) | Exposes resource IDs, names, service account emails, Jira connector state, and BigQuery log sink details. |
| [`terraform.tfvars`](file:///usr/local/google/home/jwortz/ge-app-tf/terraform.tfvars) | Active variable definitions (e.g. project `wortz-project-352116`, engine `terraform-instance-ge`, Jira collection). |
| [`terraform.tfvars.example`](file:///usr/local/google/home/jwortz/ge-app-tf/terraform.tfvars.example) | Template variable file for quick environment customization. |
| [`.env.example`](file:///usr/local/google/home/jwortz/ge-app-tf/.env.example) | Template file documenting required Jira OAuth 2.0 (3LO) and tenant environment variables. |


---

## Gemini Enterprise App in Terraform: Coverage & Approaches

### Upstream Provider Coverage Analysis

As of Google Provider (`hashicorp/google-beta` v5.x / v6.x):
1. **Natively Supported:**
   - `google_discovery_engine_search_engine`: Manages search engine creation, display name, collections, common config (company name), data store bindings, and basic search tier.
   - `google_discovery_engine_data_store`: Manages Discovery Engine data stores.
   - `google_model_armor_template`: Manages Model Armor safety, prompt injection, and PII detection templates.
   - `google_bigquery_dataset` & `google_logging_project_sink`: Manages enterprise audit log storage.
   - `google_monitoring_dashboard`: Manages observability dashboards.
2. **Current Upstream Gaps in Provider Schema:**
   - **`features` map**: The Discovery Engine API exposes an extensive dictionary of enterprise feature toggles (`agent-gallery`, `notebook-lm`, `canvas`, `video-generation`, etc.) under `PATCH .../engines/{engine_id}?updateMask=features`. This field is not yet directly declared in `google_discovery_engine_search_engine` HCL schema.
   - **`app_type` immutability**: In the Discovery Engine API, `app_type` (e.g. `APP_TYPE_INTRANET`) is immutable. Attempting to update `app_type` via `updateMask` returns HTTP 400 (`Field "updateMask" contains an immutable path "app_type"`).
   - **`required_subscription_tier`**: Subscription tiers (`SUBSCRIPTION_TIER_SEARCH_AND_ASSISTANT`) are only valid on engines created with `APP_TYPE_INTRANET`.
   - **Assistant / Agent Resource**: An official `google_discovery_engine_assistant` resource is pending upstream implementation in the Terraform Google provider.

---

### Architectural Approaches for Terraform Management

We evaluate three architectural approaches for managing Gemini Enterprise apps in Terraform:

#### Approach 1: Ephemeral Runtime ADC Synchronization (Implemented & Recommended)
- **Concept:** Standard Terraform resources (`google_discovery_engine_search_engine`, `google_discovery_engine_data_store`) manage the infrastructure lifecycle. A complementary [`terraform_data`](file:///usr/local/google/home/jwortz/ge-app-tf/gemini_app.tf#L108-L163) resource synchronizes the `features` dictionary via the Discovery Engine REST API at apply time.
- **Credential Architecture:** Uses **Application Default Credentials (ADC)** resolved dynamically inside the provisioner runtime:
  ```bash
  TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null || \
    python3 -c "import google.auth, google.auth.transport.requests; c, _ = google.auth.default(); c.refresh(google.auth.transport.requests.Request()); print(c.token)" 2>/dev/null || \
    curl -s -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" | jq -r ".access_token // empty" 2>/dev/null || \
    gcloud auth print-access-token 2>/dev/null)
  ```
- **Why Secret Manager is an Anti-Pattern for OAuth Tokens:**
  - **Expiry:** OAuth 2.0 access tokens expire in 60 minutes. Storing short-lived tokens in Secret Manager creates continuous state churn and fails when older tokens expire.
  - **Security / Secret Leakage:** Storing access tokens in Terraform variables or Secret Manager data sources leaks active credentials into plaintext `.tfstate` files.
  - **Workload Identity Alignment:** ADC seamlessly inherits the caller's identity: developer credentials in local runs, or Workload Identity Federation / Cloud Build Service Accounts in CI/CD pipelines.
- **Change Detection:** `triggers_replace = [engine.id, jsonencode(var.feature_management)]` ensures that whenever any feature flag in `terraform.tfvars` is toggled, Terraform detects the diff, recreates the `terraform_data` resource, and updates the engine in Google Cloud.

#### Approach 2: Native-Only Provider Subset
- **Concept:** Restrict Terraform exclusively to the schema attributes recognized by `hashicorp/google-beta`.
- **Characteristics:**
  - Zero provisioners or CLI dependencies.
  - Manages engines, data stores, IAM, Model Armor, and BigQuery sinks natively.
  - **Limitation:** Enterprise feature toggles (`features` map) must be configured manually via Google Cloud Console or external post-deployment scripts.
  - **Drift Handling:** Requires `lifecycle { ignore_changes = [advanced_site_search_config] }` on `google_discovery_engine_data_store` to prevent perpetual drift caused by engine attachments.

#### Approach 3: Upstream Provider Contribution (Magic Modules Roadmap)
- **Concept:** Contribute schema definitions to Google's upstream [Magic Modules](https://github.com/GoogleCloudPlatform/magic-modules) compiler.
- **Implementation Path:**
  1. Add `features` (TypeMap of TypeString) to the `SearchEngine` MMv1 YAML specification.
  2. Add `app_type` as a `ForceNew` immutable attribute to allow creating `APP_TYPE_INTRANET` engines directly.
  3. Implement `google_discovery_engine_assistant` as a child resource pointing to `projects/{p}/locations/{l}/collections/{c}/engines/{e}/assistants/{a}`.
- **Migration:** Once merged into `hashicorp/google-beta`, migrating from Approach 1 to native blocks requires only moving the `features` map into `google_discovery_engine_search_engine` and running `terraform state rm terraform_data.gemini_feature_management`.

---

## Verification & Confirmation with Test App (`terraform-instance-ge`)

The configuration was tested and validated end-to-end on the test engine **`terraform-instance-ge`** in project `wortz-project-352116`.

### 1. Initial State: All 10 Features Enabled
Configured in [`terraform.tfvars`](file:///usr/local/google/home/jwortz/ge-app-tf/terraform.tfvars):
```hcl
feature_management = {
  "agent-gallery"          = "FEATURE_STATE_ON"
  "agent-designer"         = "FEATURE_STATE_ON"
  "prompt-gallery"         = "FEATURE_STATE_ON"
  "model-selector"         = "FEATURE_STATE_ON"
  "notebook-lm"            = "FEATURE_STATE_ON"
  "session-sharing"        = "FEATURE_STATE_ON"
  "personalization-memory" = "FEATURE_STATE_ON"
  "canvas"                 = "FEATURE_STATE_ON"
  "image-generation"       = "FEATURE_STATE_ON"
  "video-generation"       = "FEATURE_STATE_ON"
}
```
**Applied:** `terraform apply` completed with HTTP 200.
**Verified via Discovery Engine API:**
```json
{
  "prompt-gallery": "FEATURE_STATE_ON",
  "session-sharing": "FEATURE_STATE_ON",
  "model-selector": "FEATURE_STATE_ON",
  "personalization-memory": "FEATURE_STATE_ON",
  "agent-designer": "FEATURE_STATE_ON",
  "canvas": "FEATURE_STATE_ON",
  "video-generation": "FEATURE_STATE_ON",
  "agent-gallery": "FEATURE_STATE_ON",
  "image-generation": "FEATURE_STATE_ON",
  "notebook-lm": "FEATURE_STATE_ON"
}
```

### 2. Live Modification Test: Disabling Features via Terraform
Modified [`terraform.tfvars`](file:///usr/local/google/home/jwortz/ge-app-tf/terraform.tfvars):
```hcl
  "image-generation" = "FEATURE_STATE_OFF"
  "video-generation" = "FEATURE_STATE_OFF"
```
**Terraform Plan Output:**
```
  # terraform_data.gemini_feature_management must be replaced
-/+ resource "terraform_data" "gemini_feature_management" {
      ~ input = {
          ~ features_json = jsonencode(
              ~ {
                  ~ image-generation = "FEATURE_STATE_ON" -> "FEATURE_STATE_OFF"
                  ~ video-generation = "FEATURE_STATE_ON" -> "FEATURE_STATE_OFF"
                }
            )
        }
    }
Plan: 1 to add, 0 to change, 1 to destroy.
```
**Applied:** Re-applied cleanly in 3 seconds.
**Verified via Discovery Engine API:**
```json
{
  "image-generation": "FEATURE_STATE_OFF",
  "personalization-memory": "FEATURE_STATE_ON",
  "prompt-gallery": "FEATURE_STATE_ON",
  "session-sharing": "FEATURE_STATE_ON",
  "video-generation": "FEATURE_STATE_OFF",
  "notebook-lm": "FEATURE_STATE_ON",
  "canvas": "FEATURE_STATE_ON",
  "model-selector": "FEATURE_STATE_ON",
  "agent-gallery": "FEATURE_STATE_ON",
  "agent-designer": "FEATURE_STATE_ON"
}
```

### 3. Reversion Test: Restoring Full Capabilities
Reverted `image-generation` and `video-generation` to `FEATURE_STATE_ON`.
**Applied:** `terraform apply` completed with HTTP 200.
**Verified via Discovery Engine API:** All 10 features returned to `FEATURE_STATE_ON`.

---

## Jira Federated & Action Data Connector Configuration

The configuration in [`main.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/main.tf) provisions and manages the **Atlassian Jira Data Connector** (`google_discovery_engine_data_connector`) within Google Discovery Engine and Gemini Enterprise.

### Key Capabilities

1. **Federated Search across 10 Jira Entities:**
   Automatically provisions and attaches dedicated Discovery Engine Data Stores in `default_collection` for each entity:
   - `project`, `issue`, `comment`, `attachment`, `bug`, `epic`, `story`, `task`, `worklog`, `board`.
2. **Business Application Platform (BAP) Actions:**
   Enables end-user conversational actions directly from the Gemini Enterprise Assistant:
   - `create_issue`, `update_issue`, `change_issue_status`, `create_comment`, `update_comment`, `upload_attachment`.
3. **Drift-Proof Lifecycle Rules:**
   Includes `lifecycle.ignore_changes` to prevent perpetual drift or destructive re-creations when Jira connectors are managed collaboratively via the Google Cloud Console and Terraform.

---

## Requirements for `.env` Configuration

To manage or provision the Jira Data Connector, create a `.env` file in the root of the repository (or copy [`.env.example`](file:///usr/local/google/home/jwortz/ge-app-tf/.env.example)):

```shell
cp .env.example .env
```

### Environment Variable Reference

| Variable | Required | Description | Example / Format | Where to Obtain |
| :--- | :---: | :--- | :--- | :--- |
| `JIRA_CLIENT` | Yes | OAuth 2.0 (3LO) Client ID | `RyA0UoXKSMmuQqEDMSLnOZQCzM0Eadic` | Atlassian Developer Console > App > Settings > Authentication |
| `JIRA_SECRET` | Yes | OAuth 2.0 (3LO) Client Secret | `ATOAwKY6...` | Atlassian Developer Console > App > Settings > Authentication |
| `JIRA_SITE` | Yes | Jira Cloud site domain | `your-company.atlassian.net` or `your-company.jira.com` | Your Atlassian Jira site URL |
| `JIRA_CLOUD_ID` | Optional | Atlassian Cloud Tenant GUID | `95336bab-a974-4f29-9c1a-0f61a19cd406` | Atlassian API (`https://<site>/_edge/tenant_info`) |

### How `.env` is Loaded

[`main.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/main.tf) automatically detects and parses `.env` at plan/apply time:

```hcl
locals {
  env_file_exists = fileexists("${path.module}/.env")
  env_lines = local.env_file_exists ? [
    for line in split("\n", file("${path.module}/.env")) :
    trimspace(line) if trimspace(line) != "" && !startswith(trimspace(line), "#")
  ] : []
  env_vars = {
    for line in local.env_lines :
    trimspace(split("=", line)[0]) => trimspace(join("=", slice(split("=", line), 1, length(split("=", line)))))
    if length(split("=", line)) >= 2
  }

  jira_client_raw = try(local.env_vars["JIRA_CLIENT"], var.jira_client)
  jira_secret_raw = try(local.env_vars["JIRA_SECRET"], var.jira_secret)
  jira_site_raw   = try(local.env_vars["JIRA_SITE"], var.jira_site)
  jira_cloud_raw  = try(local.env_vars["JIRA_CLOUD_ID"], var.jira_cloud_id)
}
```

> [!IMPORTANT]
> **Resolution Priority:**
> 1. Values declared in `.env` (highest priority for local development).
> 2. Terraform variables (`var.jira_client`, `var.jira_secret`, `var.jira_site`, `var.jira_cloud_id`) or `TF_VAR_*` environment variables (ideal for CI/CD pipelines).
> 3. Default fallback values defined in [`variables.tf`](file:///usr/local/google/home/jwortz/ge-app-tf/variables.tf).

> [!CAUTION]
> **Security Mandate:** The `.env` file contains sensitive OAuth client secrets and is explicitly ignored in [`.gitignore`](file:///usr/local/google/home/jwortz/ge-app-tf/.gitignore). Never commit `.env` or state files with unencrypted credentials to version control.

---

## Managing Existing Jira Connectors in Terraform

If you already created a Jira connector in the Google Cloud Console (e.g. `jira-federated_1782320633397`), import it into Terraform management with:

```bash
terraform import google_discovery_engine_data_connector.jira_federated \
  projects/<PROJECT_ID>/locations/global/collections/<COLLECTION_ID>/dataConnector
```

For the active connector in `wortz-project-352116`:
```bash
terraform import google_discovery_engine_data_connector.jira_federated \
  projects/wortz-project-352116/locations/global/collections/jira-federated_1782320633397/dataConnector
```

After importing, run:
```bash
terraform plan
terraform apply
```
Terraform will report:
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

---

## How to Deploy & Operate


### Step 1: Authenticate with ADC
```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project <your-project-id>
```

### Step 2: Configure Environment
Copy and customize the variable file:
```bash
cp terraform.tfvars.example terraform.tfvars
```
Set your project details in `terraform.tfvars`.

### Step 3: Initialize & Validate
```bash
terraform init
terraform validate
```

### Step 4: Plan & Apply
```bash
terraform plan
terraform apply
```

### Step 5: Toggling Features Day-2
Simply modify the feature values in `terraform.tfvars`:
```hcl
feature_management = {
  "notebook-lm"      = "FEATURE_STATE_OFF"
  "video-generation" = "FEATURE_STATE_OFF"
  # ...
}
```
Run:
```bash
terraform apply
```
Terraform automatically detects the changes and syncs them to your Gemini Enterprise application.
