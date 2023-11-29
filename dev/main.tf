module "gcs" {
  source = "../modules/security"

  project_id         = local.project_id
  audit_logging_apis = local.audit_logging_apis
}
