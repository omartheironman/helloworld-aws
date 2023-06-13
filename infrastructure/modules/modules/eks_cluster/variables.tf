variable "region" {
  type        = string
  description = "The AWS region."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "environment_shortname" {
  type        = string
  description = "Environment short name."
}

variable "ovpn_private_ip" {
  type        = string
  description = "OpenVPN."
}

variable "account_id" {
  type        = string
  description = "AWS Account ID number of the account."
}

variable "project" {
  type        = string
  description = "Project name."
}

variable "eks_cluster_version" {
  type        = number
  description = "Kubernetes version."
  default     = 1.27
}

variable "eks_node_group_min_size" {
  type        = number
  description = "Minimum number of Kubernetes worker nodes in the cluster."
  default     = 3
}

variable "eks_node_group_max_size" {
  type        = number
  description = "Maximum number of Kubernetes worker nodes in the cluster."
  default     = 10
}

variable "eks_node_group_desired_size" {
  type        = number
  description = "Desired number of Kubernetes worker nodes in the cluster."
  default     = 3
}

variable "eks_managed_node_group_instance_types" {
  type        = list(any)
  description = "List of instance types to use for the EKS node group."
  default     = ["t3.xlarge"]
}

variable "eks_node_group_disk_size" {
  type        = number
  description = "Default size of the disk for the EKS nodes."
  default     = 100
}

# Input from vpc module output
variable "vpc_id" {
  type        = string
  description = "Id of VPC."
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "Private subnet of vpc."
}




# External DNS
variable "attach_external_dns_policy" {
  description = "Determines whether to attach the External DNS IAM policy to the role"
  type        = bool
  default     = false
}

variable "external_dns_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs to allow External DNS to manage records"
  type        = list(string)
  default     = ["arn:aws:route53:::hostedzone/*"]
}

variable "aws_auth_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}