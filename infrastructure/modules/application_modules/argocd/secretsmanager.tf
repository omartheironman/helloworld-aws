resource "aws_secretsmanager_secret" "argocd" {
  name                    = "eks/argocd/${var.environment}"
  description             = "ArgoCD secrets managed by Terraform."
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "argocd" {
  secret_id = aws_secretsmanager_secret.argocd.id
  secret_string = jsonencode({
    "argocd_admin_password" = random_password.argocd_admin_password.result,
    "argocd_deploy_key"     = var.deploy_key
  })
}

resource "random_password" "argocd_admin_password" {
  length  = 20
  special = true
}
