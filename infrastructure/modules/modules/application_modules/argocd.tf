module "argocd" {
  source = "./modules/argocd"

  account_id                = var.account_id
  argocd_namespace          = var.argocd_namespace
  argocd_release_name       = var.argocd_release_name
  argocd_chart_version      = var.argocd_chart_version
  argocd_timeout_seconds    = var.argocd_timeout_seconds
  eks_oidc_provider         = module.eks.oidc_provider
  project                   = var.project
  deploy_key                = tls_private_key.github.private_key_pem
  argocd_apps_release_name  = var.argocd_apps_release_name
  argocd_apps_chart_version = var.argocd_apps_chart_version
}

resource "tls_private_key" "github" {
  algorithm = "RSA"
}

resource "github_repository_deploy_key" "ops-gitops" {
  title      = "${var.project}-${var.environment_shortname}"
  repository = "${var.project}-gitops"
  key        = tls_private_key.github.public_key_openssh
  read_only  = "true"
}
