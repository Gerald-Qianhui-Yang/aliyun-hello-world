locals {
  tags = {
    project = var.project
    env     = var.env
    owner   = var.owner
  }
}

# --- Security Group ---

resource "alicloud_security_group" "sae" {
  security_group_name = "${var.project}-${var.env}-sae-sg"
  vpc_id              = var.vpc_id
  tags                = local.tags
}

resource "alicloud_security_group_rule" "allow_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "8080/8080"
  security_group_id = alicloud_security_group.sae.id
  cidr_ip           = "172.16.0.0/16"
}

# --- RDS PostgreSQL ---

resource "alicloud_db_instance" "pg" {
  engine                   = "PostgreSQL"
  engine_version           = "14.0"
  instance_type            = var.rds_instance_type
  instance_storage         = var.rds_storage_size
  db_instance_storage_type = "cloud_essd"
  vswitch_id               = var.vswitch_id
  instance_name            = "${var.project}-${var.env}-pg"
  security_ips             = ["172.16.0.0/16"]
  tags                     = local.tags
}

resource "alicloud_rds_account" "master" {
  db_instance_id   = alicloud_db_instance.pg.id
  account_name     = "${replace(var.project, "-", "")}admin"
  account_password = var.db_password
  account_type     = "Super"
}

resource "alicloud_db_database" "app" {
  instance_id    = alicloud_db_instance.pg.id
  data_base_name = "${replace(var.project, "-", "")}_${var.env}"
}

# --- SAE ---

resource "alicloud_sae_namespace" "main" {
  namespace_id          = "${var.region}:${var.project}-${var.env}"
  namespace_name        = "${var.project}-${var.env}"
  namespace_description = "${var.project} ${var.env} SAE namespace"
}

resource "alicloud_sae_application" "app" {
  app_name          = "${var.project}-${var.env}-app"
  namespace_id      = alicloud_sae_namespace.main.namespace_id
  package_type      = "Image"
  image_url         = var.image_url
  acr_instance_id   = var.acr_instance_id
  cpu               = var.sae_cpu
  memory            = var.sae_memory
  replicas          = var.sae_replicas
  vpc_id            = var.vpc_id
  vswitch_id        = var.vswitch_id
  security_group_id = alicloud_security_group.sae.id

  envs = jsonencode([
    {
      name  = "DATABASE_URL"
      value = "postgresql://${alicloud_rds_account.master.account_name}:${var.db_password}@${alicloud_db_instance.pg.connection_string}:${alicloud_db_instance.pg.port}/${alicloud_db_database.app.data_base_name}"
    },
    {
      name  = "PORT"
      value = "8080"
    }
  ])
}
