module "ops-adminportal-db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "5.9.0"
  identifier = "${var.project}-omar-rds"

  engine               = "postgres"
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.db_name
  username = var.username
  password = random_password.ops-adminportal-db-password.result
  port     = 5432

  multi_az               = true
  db_subnet_group_name   = var.vpc_database_subnet_group
  vpc_security_group_ids = [module.rds-security-group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true
  backup_retention_period         = 1
  skip_final_snapshot             = true
  deletion_protection             = false

  performance_insights_enabled = false
  create_monitoring_role       = false

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]
}

