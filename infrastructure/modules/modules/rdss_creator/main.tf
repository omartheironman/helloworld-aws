module "create_rds" {
  source   = "./rds"
#   for_each = var.rds_instance_list
  count    = length(var.rds_instance_list)

  # Use each.value to access the values for each RDS instance
  engine                    = var.rds_instance_list[count.index].engine
  engine_version            = var.rds_instance_list[count.index].engine_version
  family                    = var.rds_instance_list[count.index].family
  major_engine_version      = var.rds_instance_list[count.index].major_engine_version
  instance_class            = var.rds_instance_list[count.index].instance_class
  vpc_cidr                  = var.vpc_cidr
  vpc_id                    = var.vpc_id
  vpc_database_subnet_group = var.vpc_database_subnet_group
  username                  = var.rds_instance_list[count.index].username
  db_name                   = var.rds_instance_list[count.index].db_name
  rds_security_group        = var.rds_instance_list[count.index].rds_security_group
  max_allocated_storage     = var.rds_instance_list[count.index].max_allocated_storage
  allocated_storage         = var.rds_instance_list[count.index].allocated_storage
  project                   = var.project
}