module "eks_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = "${var.project}-${var.environment}-eks-irsa-role"

  # Elastic Block/File Storage
  attach_ebs_csi_policy = true
  attach_efs_csi_policy = true

  # External DNS
  # attach_external_dns_policy    = true
  # external_dns_hosted_zone_arns = [data.aws_route53_zone.private.arn]

  # External Secret
  attach_external_secrets_policy        = true
  external_secrets_ssm_parameter_arns   = ["*"]
  external_secrets_secrets_manager_arns = ["*"]

  # Load Balancer
  attach_load_balancer_controller_policy                          = true
  attach_load_balancer_controller_targetgroup_binding_only_policy = true

  oidc_providers = {
    ebs = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
    efs = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
    dns = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
    lb = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
