module "atlantis_role" {
  source     = "./modules/atlantis-iam"
  account_id = var.account_id

  infra_provisiong_account_ids = {
    ops = "123456"
    dev = "54321"
    prd = "00000"
  }

  atlantis_base_role       = "atlantis-sm-role"
  atlantis_namespace       = "atlantis"
  atlantis_service_account = "atlantis-sm"
  eks_oidc_provider        = module.eks.oidc_provider
}

module "atlantis_secret_manager" {
  source                  = "./modules/secrets_manager_sops"
  secret_path             = "eks/atlantis"
  secrets_description     = "atlantis secrets used by argocd."
  sops_secret_object_name = "atlantis"
}
