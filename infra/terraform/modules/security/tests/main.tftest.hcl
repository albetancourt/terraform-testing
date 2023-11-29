provider "google" {
  project = "ninth-beacon-401418"
  region  = "us-west2"
}

variables {
  project_id = "ninth-beacon-401418"
  
  audit_logging_apis = [
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

run "audit_logs_should_be_enabled" {
  command = apply

  assert {
    condition = toset(var.audit_logging_apis) == toset(
      # APIs with audit logs enabled
      flatten([
        for item in google_project_iam_audit_config.default[*] : [
          for service, config in item :
            service if anytrue([
              for log in config.audit_log_config : log.log_type == "ADMIN_READ"
            ])
        ]
      ])
    )

    error_message = "Audit logs were not enabled."
  }

}
