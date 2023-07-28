variable "rds_instance_list" {
  description = "List of RDS instances"
  type = list(object({
    engine                = string
    engine_version        = string
    family                = string
    major_engine_version  = string
    instance_class        = string
    rds_security_group    = string
    allocated_storage     = number
    max_allocated_storage = number
    db_name               = string
    username              = string
  }))
}

variable "vpc_database_subnet_group" {
  description = "Database username."
  type        = string
}

variable "vpc_id" {
  description = "VPC Id to use"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "project" {
  description = "project name"
  type        = string
}