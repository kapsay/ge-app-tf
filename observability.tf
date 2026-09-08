# ==============================================================================
# Observability, Telemetry & Audit Logging Configuration
# ==============================================================================
# Sets up end-to-end OpenTelemetry tracing to Cloud Trace, metric instrumentation
# to Cloud Monitoring, and full audit logging of prompts, responses, and Model Armor
# screening events to a dedicated, encrypted BigQuery dataset via Cloud Logging.

# ------------------------------------------------------------------------------
# 1. Google Cloud Service Agents / Identities
# ------------------------------------------------------------------------------
# Discovery Engine Service Agent
resource "google_project_service_identity" "discovery_engine_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "discoveryengine.googleapis.com"
}

# Model Armor Service Agent
resource "google_project_service_identity" "model_armor_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "modelarmor.googleapis.com"
}

# ------------------------------------------------------------------------------
# 2. IAM Roles for Service Agents (Discovery Engine & Model Armor)
# ------------------------------------------------------------------------------

# Allow Discovery Engine to invoke Model Armor screening templates
resource "google_project_iam_member" "discovery_engine_model_armor_user" {
  project = var.project_id
  role    = "roles/modelarmor.user"
  member  = "serviceAccount:${google_project_service_identity.discovery_engine_sa.email}"
}

# Allow Discovery Engine to write audit logs to Cloud Logging
resource "google_project_iam_member" "discovery_engine_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_project_service_identity.discovery_engine_sa.email}"
}

# OpenTelemetry: Allow Discovery Engine to push traces/spans to Cloud Trace
resource "google_project_iam_member" "discovery_engine_trace_agent" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_project_service_identity.discovery_engine_sa.email}"
}

# OpenTelemetry: Allow Discovery Engine to publish telemetry metrics to Cloud Monitoring
resource "google_project_iam_member" "discovery_engine_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_project_service_identity.discovery_engine_sa.email}"
}

# Allow Model Armor to write sanitize/screening logs
resource "google_project_iam_member" "model_armor_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_project_service_identity.model_armor_sa.email}"
}

# Allow Model Armor to emit latency spans to Cloud Trace
resource "google_project_iam_member" "model_armor_trace_agent" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_project_service_identity.model_armor_sa.email}"
}

# ------------------------------------------------------------------------------
# 3. Secure BigQuery Audit Dataset
# ------------------------------------------------------------------------------
# Stores structured audit logs for prompts, responses, and security screening events.
resource "google_bigquery_dataset" "ge_audit_logs" {
  provider    = google
  project     = var.project_id
  dataset_id  = var.bigquery_dataset_id
  location    = var.bigquery_dataset_location
  description = "Secure audit dataset capturing Gemini Enterprise Discovery Engine prompts, responses, and Model Armor screening events."

  default_table_expiration_ms = var.log_retention_days * 86400 * 1000

  labels = {
    environment = "production"
    managed_by  = "terraform"
    application = "gemini-enterprise-observability"
  }
}

# ------------------------------------------------------------------------------
# 4. Cloud Logging Project Sink
# ------------------------------------------------------------------------------
# Captures all Discovery Engine and Model Armor payload logs and routes to BigQuery.
resource "google_logging_project_sink" "discovery_engine_sink" {
  provider               = google
  project                = var.project_id
  name                   = var.log_sink_name
  destination            = "bigquery.googleapis.com/${google_bigquery_dataset.ge_audit_logs.id}"
  unique_writer_identity = true

  filter = <<-EOT
    resource.type = "consumed_api" AND
    resource.labels.service = ("discoveryengine.googleapis.com" OR "modelarmor.googleapis.com")
    OR logName =~ "discoveryengine.googleapis.com"
    OR logName =~ "modelarmor.googleapis.com"
    OR protoPayload.serviceName = ("discoveryengine.googleapis.com" OR "modelarmor.googleapis.com")
  EOT

  bigquery_options {
    use_partitioned_tables = true
  }

  depends_on = [
    google_bigquery_dataset.ge_audit_logs
  ]
}

# Grant the log sink's unique writer identity write access to the BigQuery dataset
resource "google_project_iam_member" "log_sink_bigquery_writer" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = google_logging_project_sink.discovery_engine_sink.writer_identity
}

# ------------------------------------------------------------------------------
# 5. OpenTelemetry & Cloud Monitoring Telemetry Dashboard
# ------------------------------------------------------------------------------
# Pre-configures a Cloud Monitoring dashboard for Gemini Enterprise latency,
# Model Armor safety blocks, and request volume observability.
resource "google_monitoring_dashboard" "ge_observability_dashboard" {
  provider       = google
  project        = var.project_id
  dashboard_json = jsonencode({
    displayName = "Gemini Enterprise & Model Armor Observability"
    gridLayout = {
      columns = "2"
      widgets = [
        {
          title = "Gemini Enterprise - Request Volume & API Consumption"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"serviceruntime.googleapis.com/api/request_count\" resource.type=\"consumed_api\" resource.label.service=\"discoveryengine.googleapis.com\""
                  }
                }
                plotType = "LINE"
              }
            ]
          }
        },
        {
          title = "Gemini Enterprise - End-to-End Latency (Cloud Trace)"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"serviceruntime.googleapis.com/api/request_latencies\" resource.type=\"consumed_api\" resource.label.service=\"discoveryengine.googleapis.com\""
                  }
                }
                plotType = "LINE"
              }
            ]
          }
        },
        {
          title = "Model Armor - Screening Operations & Blocked Policy Violations"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"consumed_api\" resource.label.service=\"modelarmor.googleapis.com\""
                  }
                }
                plotType = "STACKED_BAR"
              }
            ]
          }
        },
        {
          title = "Cloud Trace - OpenTelemetry Span Latency"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"custom.googleapis.com/opentelemetry/span_duration\""
                  }
                }
                plotType = "LINE"
              }
            ]
          }
        }
      ]
    }
  })
}
