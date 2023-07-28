variable "engine" {
  description = "The database engine for the RDS instance"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "14.3"
}

variable "family" {
  description = "The family of the database engine"
  type        = string
  default     = "postgres14"
}

variable "major_engine_version" {
  description = "The major version of the database engine"
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t4g.medium"
}

variable "max_allocated_storage" {
  description = "Max storage to allocate."
  type        = number
  default     = 100
}

variable "allocated_storage" {
  description = "RDS storage to allocate."
  type        = number
  default     = 20
}


#### Required
variable "vpc_id" {
  description = "VPC Id to use"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "rds_security_group" {
  description = "RDS Security group"
  type        = string
  default     = "Postgresql_Sec_Group"
}

variable "db_name" {
  description = "Name of database."
  type        = string
}

variable "username" {
  description = "Database username."
  type        = string
}

variable "vpc_database_subnet_group" {
  description = "Database username."
  type        = string
}

variable "project" {
  description = "project name."
  type        = string
}

