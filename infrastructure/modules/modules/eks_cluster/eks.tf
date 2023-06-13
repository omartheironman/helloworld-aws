
data "aws_iam_roles" "sso_administratorAccess" {
  name_regex  = "AWSReservedSSO_AdministratorAccess.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                    = "${var.project}-${var.environment}"
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.eks_irsa_role.iam_role_arn
    }
  }

  # Encryption key
  create_kms_key = true
  cluster_encryption_config = {
    resources = ["secrets"]
  }
  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.vpc_private_subnets
  control_plane_subnet_ids = var.vpc_private_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    # ingress_vpn = {
    #   description = "From VPN"
    #   protocol    = "-1"
    #   from_port   = 0
    #   to_port     = 0
    #   type        = "ingress"
    #   cidr_blocks = [var.ovpn_private_ip]
    # }
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  /* node_security_group_ntp_ipv4_cidr_block = ["169.254.169.123/32"] */
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type        = "AL2_x86_64"
    use_name_prefix = false
    instance_types  = var.eks_managed_node_group_instance_types
  }

  eks_managed_node_groups = {
    # WARN: If this change, update the Airflow Trusted policy too
    default = {
      name = "${var.project}-${var.environment}-default"

      min_size     = var.eks_node_group_min_size
      max_size     = var.eks_node_group_max_size
      desired_size = var.eks_node_group_desired_size

      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.eks_node_group_disk_size
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        },
      ]

      iam_role_additional_policies = {
        logging = aws_iam_policy.logging.arn
      }
    }
  }

  # OIDC Identity provider
  cluster_identity_providers = {
    irsa = {
      client_id = module.eks_irsa_role.iam_role_unique_id
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${var.account_id}:${var.project}-${var.environment}-terraform-test-role"
      username = "omartest-de-terraform-role"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/${one(data.aws_iam_roles.sso_administratorAccess.names)}"
      username = one(data.aws_iam_roles.sso_administratorAccess.names)
      groups   = ["system:masters"]
    }
  ]

  kms_key_administrators = concat([one(data.aws_iam_roles.sso_administratorAccess.arns)], [for user in var.aws_auth_users : user.userarn])


  aws_auth_users = var.aws_auth_users

  aws_auth_accounts = [
    var.account_id
  ]
}