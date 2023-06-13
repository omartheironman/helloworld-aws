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

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key to connect to the HTTPs API."
  default     = "fa7c638e6c28ed9edf4643d0cb65cb2a"
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application Key to connect to the API."
  default     = "1938c8052dc8469a51f2a26fc3dc5db084d0c3a5"
}
