output "sae_app_id" {
  description = "SAE application ID"
  value       = alicloud_sae_application.app.id
}

output "sae_app_name" {
  description = "SAE application name"
  value       = alicloud_sae_application.app.app_name
}

output "rds_instance_id" {
  description = "RDS instance ID"
  value       = alicloud_db_instance.pg.id
}

output "rds_connection_string" {
  description = "RDS internal connection string"
  value       = alicloud_db_instance.pg.connection_string
  sensitive   = true
}

output "rds_port" {
  description = "RDS port"
  value       = alicloud_db_instance.pg.port
}
