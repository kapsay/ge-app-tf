# Google Cloud Gemini Enterprise App - Step-by-Step Execution Guide

This document provides a comprehensive, production-ready operational guide for deploying, verifying, managing, and tearing down the **Gemini Enterprise Application** infrastructure defined in this repository.

---

## Table of Contents

1. [Prerequisites & System Requirements](#1-prerequisites--system-requirements)
2. [IAM Roles & Permissions Needed](#2-iam-roles--permissions-needed)
3. [Step 1: Authenticate with Google Cloud](#step-1-authenticate-with-google-cloud)
4. [Step 2: Enable Required Google Cloud APIs](#step-2-enable-required-google-cloud-apis)
5. [Step 3: Configure Environment Variables (`terraform.tfvars`)](#step-3-configure-environment-variables-terraformtfvars)
6. [Step 4: Initialize Terraform](#step-4-initialize-terraform)
7. [Step 5: Validate and Plan the Deployment](#step-5-validate-and-plan-the-deployment)
8. [Step 6: Apply the Terraform Configuration](#step-6-apply-the-terraform-configuration)
9. [Step 7: Post-Deployment Verification](#step-7-post-deployment-verification)
10. [Step 8: Day-2 Operations & Feature Toggles](#step-8-day-2-operations--feature-toggles)
11. [Step 9: Troubleshooting Common Issues](#step-9-troubleshooting-common-issues)
12. [Step 10: Teardown & Clean-up](#step-10-teardown--clean-up)

---

## 1. Prerequisites & System Requirements

Before running the deployment, ensure the following tools are installed on your workstation:

| Tool | Minimum Version | Purpose | Installation Check |
| :--- | :---: | :--- | :--- |
| **Terraform** or **OpenTofu** | `1.5.0+` | Infrastructure as Code provisioning engine | `terraform version` |
| **Google Cloud CLI (`gcloud`)** | `480.0.0+` | GCP authentication and API interactions | `gcloud version` |
| **cURL** | Any standard | Used by optional feature-sync local-exec hooks | `curl --version` |

---

## 2. IAM Roles & Permissions Needed

The identity running `terraform apply` (either your user account or a deployment CI/CD service account) must have the following IAM roles on the target GCP project:

- **Discovery Engine Admin** (`roles/discoveryengine.admin`) — Create and configure Data Stores, Search Engines, and Assistants.
- **Model Armor Admin** (`roles/modelarmor.admin`) — Create and manage Model Armor security screening templates.
- **Project IAM Admin** (`roles/resourcemanager.projectIamAdmin`) — Grant required roles (`roles/modelarmor.user`, `roles/cloudtrace.agent`, `roles/logging.logWriter`) to Google-managed service agents.
- **BigQuery Admin** (`roles/bigquery.admin`) — Create and manage the audit log BigQuery dataset.
- **Logging Admin** (`roles/logging.admin`) — Create and configure the project-level Cloud Logging export sink.
- **Monitoring Dashboard Editor** (`roles/monitoring.dashboardEditor`) — Create the Cloud Monitoring observability dashboard.
- **Service Usage Admin** (`roles/serviceusage.serviceUsageAdmin`) — Verify and query API enablement.

---

## Step 1: Authenticate with Google Cloud

Authenticate your terminal session and configure Application Default Credentials (ADC) so Terraform can authenticate against GCP APIs:

```bash
# 1. Login to your Google Cloud user account
gcloud auth login

# 2. Acquire Application Default Credentials (ADC) used by the Terraform provider
gcloud auth application-default login

# 3. Set your active target Google Cloud Project ID
export GCP_PROJECT_ID="your-target-gcp-project-id"
gcloud config set project "$GCP_PROJECT_ID"
```

---

## Step 2: Enable Required Google Cloud APIs

Ensure all the necessary Google Cloud services are enabled in your project:

```bash
gcloud services enable \
  discoveryengine.googleapis.com \
  modelarmor.googleapis.com \
  logging.googleapis.com \
  cloudtrace.googleapis.com \
  monitoring.googleapis.com \
  bigquery.googleapis.com
```

> [!NOTE]
> Newly enabled APIs may take 30–60 seconds to fully propagate across Google Cloud global endpoints.

---

## Step 3: Configure Environment Variables (`terraform.tfvars`)

1. Change directory to the Terraform configuration root:
   ```bash
   cd /Users/kapsay/Documents/Work/antigravity/tf_geapp
   ```

2. Copy the provided template to create your `terraform.tfvars`:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Open `terraform.tfvars` in your editor and update the parameters:
   ```hcl
   # Target Project
   project_id           = "your-actual-gcp-project-id"
   region               = "us"
   location             = "global"
   model_armor_location = "us-central1"
   company_name         = "My Company Enterprise"

   # Data Store & App Identifiers
   data_store_id        = "my_demo_ds"
   data_store_display_name = "My Demo Data Store"
   engine_id            = "my_demo_app"
   engine_display_name  = "My Demo Gemini Enterprise App"
   assistant_id         = "my_demo_agent"
   assistant_display_name = "My Demo Agent"

   # Feature Toggles (ON / OFF)
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

   # Observability Settings
   log_sink_name             = "ge-discovery-engine-sink"
   bigquery_dataset_id       = "gemini_enterprise_logs"
   bigquery_dataset_location = "US"
   log_retention_days        = 90
   ```

---

## Step 4: Initialize Terraform

Initialize the Terraform working directory to download the required provider plugins (`google`, `google-beta`, and `null`):

```bash
terraform init
```

**Expected output:**
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/google versions matching ">= 6.0.0, < 7.0.0"...
- Finding hashicorp/google-beta versions matching ">= 6.0.0, < 7.0.0"...
- Finding hashicorp/null versions matching ">= 3.2.0"...
- Installing hashicorp/google v6.x...
- Installing hashicorp/google-beta v6.x...
- Installing hashicorp/null v3.x...

Terraform has been successfully initialized!
```

---

## Step 5: Validate and Plan the Deployment

1. **Check configuration syntax:**
   ```bash
   terraform validate
   ```
   *Expected:* `Success! The configuration is valid.`

2. **Generate and inspect the execution plan:**
   ```bash
   terraform plan -out=tfplan
   ```

3. **Verify the planned resources:**
   Ensure the plan shows **12–14 resources to add**:
   - `google_model_armor_template.ge_model_armor_template`
   - `google_discovery_engine_data_store.my_demo_ds`
   - `google_discovery_engine_search_engine.my_demo_app`
   - `google_discovery_engine_assistant.my_demo_agent`
   - `null_resource.gemini_feature_management`
   - `google_project_service_identity.discovery_engine_sa`
   - `google_project_service_identity.model_armor_sa`
   - IAM role bindings for Discovery Engine and Model Armor
   - `google_bigquery_dataset.ge_audit_logs`
   - `google_logging_project_sink.discovery_engine_sink`
   - `google_project_iam_member.log_sink_bigquery_writer`
   - `google_monitoring_dashboard.ge_observability_dashboard`

---

## Step 6: Apply the Terraform Configuration

Apply the saved execution plan:

```bash
terraform apply tfplan
```

*(Or run `terraform apply` directly and confirm with `yes`).*

> [!IMPORTANT]
> The apply phase typically takes **2 to 4 minutes**. Google Cloud Discovery Engine data stores and Intranet search engines undergo internal validation and indexing setup before returning ready.

Once complete, Terraform will display all outputs defined in [`outputs.tf`](file:///Users/kapsay/Documents/Work/antigravity/tf_geapp/outputs.tf).

---

## Step 7: Post-Deployment Verification

### 1. View Terraform Outputs
```bash
terraform output
```

You will see the generated resource IDs, service agent accounts, and log sink details:
```
assistant_display_name            = "My Demo Agent"
assistant_id                      = "my_demo_agent"
bigquery_audit_dataset_id         = "gemini_enterprise_logs"
cloud_logging_sink_name           = "ge-discovery-engine-sink"
cloud_logging_sink_writer_identity = "serviceAccount:p123456789-987654@gcp-sa-logging.iam.gserviceaccount.com"
data_store_id                     = "my_demo_ds"
discovery_engine_service_account  = "service-123456789@gcp-sa-discoveryengine.iam.gserviceaccount.com"
engine_app_type                   = "APP_TYPE_INTRANET"
engine_id                         = "my_demo_app"
model_armor_template_id           = "ge-model-armor-template"
model_armor_template_name         = "projects/.../locations/us-central1/templates/ge-model-armor-template"
```

### 2. Verify in Google Cloud Console
- **Gemini Enterprise (Discovery Engine):**
  1. Open [Google Cloud Console > Agent Builder / Discovery Engine](https://console.cloud.google.com/gen-app-builder).
  2. Under **Apps**, select `my_demo_app` (`My Demo Gemini Enterprise App`).
  3. Navigate to **Configurations > Feature Management** to confirm that the 10 features (Agent Gallery, Agent Designer, Canvas, etc.) are active.
  4. Under **Data Stores**, confirm `my_demo_ds` is linked with solution type `Chat`.

- **Model Armor:**
  1. Open [Google Cloud Console > Model Armor](https://console.cloud.google.com/vertex-ai/model-armor).
  2. Select the `us-central1` location.
  3. Verify `ge-model-armor-template` exists with `INSPECT_AND_BLOCK` enforcement, PI/Jailbreak (`MEDIUM_AND_ABOVE`), Malicious URI filtering, and SDP basic config.

- **Cloud Logging & BigQuery:**
  1. Navigate to [BigQuery](https://console.cloud.google.com/bigquery).
  2. Locate the dataset `gemini_enterprise_logs`.
  3. Verify partitioned tables receive audit logs when the Gemini Enterprise application is queried.

- **Cloud Monitoring Dashboard:**
  1. Navigate to [Cloud Monitoring > Dashboards](https://console.cloud.google.com/monitoring/dashboards).
  2. Open **"Gemini Enterprise & Model Armor Observability"** to view real-time API latency and block rates.

---

## Step 8: Day-2 Operations & Feature Toggles

To toggle features or adjust security parameters without disrupting your app:

1. **Toggle a Feature:**
   Open `terraform.tfvars` and change any feature state, for example:
   ```hcl
   feature_management = {
     "video-generation" = "FEATURE_STATE_OFF" # Disable video generation
     # ... keep others ON
   }
   ```
2. **Re-run Plan and Apply:**
   ```bash
   terraform plan
   terraform apply
   ```
   Terraform will cleanly update only the feature sync state.

---

## Step 9: Troubleshooting Common Issues

| Issue | Cause | Resolution |
| :--- | :--- | :--- |
| `API [discoveryengine.googleapis.com] not enabled` | API was not activated prior to apply | Run `gcloud services enable discoveryengine.googleapis.com` and re-run apply. |
| `Permission denied on service account` | The deploying identity lacks `roles/resourcemanager.projectIamAdmin` | Ensure your user/service account can assign IAM roles to service agents. |
| `Model Armor location unsupported` | Model Armor templates are available in specific regional endpoints (e.g. `us-central1`) | Ensure `model_armor_location = "us-central1"` in `terraform.tfvars`. |
| `BigQuery Sink write error` | Sink writer identity needs permission propagation | Handled automatically by `google_project_iam_member.log_sink_bigquery_writer`; allow up to 60s for IAM propagation. |

---

## Step 10: Teardown & Clean-up

To safely remove all created resources and avoid ongoing cloud costs:

```bash
# 1. Preview resources to be destroyed
terraform plan -destroy

# 2. Destroy infrastructure
terraform destroy
```

Confirm the prompt with `yes` when prompted. All search engines, assistants, data stores, Model Armor templates, dashboards, and log sinks will be cleanly decommissioned.
