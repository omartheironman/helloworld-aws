variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}


variable "vpc_database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}


variable "region" {
  type        = string
  description = "The AWS region."
}

variable "vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR."
}

variable "project" {
  type        = string
  description = "Project name."
}

variable "environment" {
  type        = string
  description = "Environment name."
}
