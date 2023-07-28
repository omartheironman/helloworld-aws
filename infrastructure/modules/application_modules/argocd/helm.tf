locals {
  argocd_gitops_repo = "${var.project}-gitops"
}

resource "helm_release" "argocd" {
  namespace        = var.argocd_namespace
  create_namespace = true
  name             = var.argocd_release_name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  timeout          = var.argocd_timeout_seconds
  values = [
    templatefile("${path.module}/values.yaml",
      {
        argocd_gitops_repo = local.argocd_gitops_repo,
        deploy_key         = split("\n", var.deploy_key)
    })
  ]

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(random_password.argocd_admin_password.result)
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "helm_release" "argocd-app-of-apps" {
  namespace  = var.argocd_namespace
  name       = var.argocd_apps_release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.argocd_apps_chart_version
  values = [
    templatefile("${path.module}/values-app.yaml",
      {
        argocd_gitops_repo = local.argocd_gitops_repo,
        environment        = var.environment,
    })
  ]
  depends_on = [
    helm_release.argocd
  ]
  lifecycle {
    ignore_changes = all
  }
}
