variable "account_id" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "argocd_release_name" {
  type = string
}

variable "argocd_apps_release_name" {
  type = string
}

variable "argocd_chart_version" {
  type = string
}

variable "argocd_apps_chart_version" {
  type = string
}

variable "argocd_timeout_seconds" {
  type = number
}

variable "eks_oidc_provider" {
  type = string
}

variable "project" {
  type        = string
  description = "Project name."
}

variable "deploy_key" {
  type        = string
  description = "Deploy key for ArgoCD"
}

variable "environment" {
  type        = string
  description = "Environment name."
}
