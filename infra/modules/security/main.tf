
resource "google_project_iam_audit_config" "default" {
  for_each = toset(var.audit_logging_apis)

  project = var.project_id
  service = each.value

  audit_log_config {
    log_type = "ADMIN_READ"
  }

  audit_log_config {
    log_type = "DATA_READ"
  }

  audit_log_config {
    log_type = "DATA_WRITE"
  }



}
