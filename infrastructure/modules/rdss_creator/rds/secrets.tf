resource "random_password" "ops-adminportal-db-password" {
  length  = 20
  special = true
}

resource "aws_secretsmanager_secret" "ops-adminportal-db" {
  name        = "${var.project}-omar-test/user-postgresql-db"
  description = "ops-adminportal password used to access Postgresql."
}

resource "aws_secretsmanager_secret_version" "ops-adminportal-db-password" {
  secret_id     = aws_secretsmanager_secret.ops-adminportal-db.id
  secret_string = random_password.ops-adminportal-db-password.result
}

module "rds-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.rds_security_group
  description = "PostgreSQL security group"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = var.vpc_cidr
    },
  ]
}