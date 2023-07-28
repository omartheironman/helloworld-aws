module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.prefix
  cidr = var.vpc_cidr

  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets
  database_subnets = var.vpc_database_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  create_igw           = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  manage_default_security_group = true
  default_security_group_name   = "${local.prefix}-sg"

  default_security_group_egress = [{
    cidr_blocks = "0.0.0.0/0"
  }]

  default_security_group_ingress = [{
    description = "Allow all internal TCP and UDP"
    self        = true
  }]

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.prefix}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.prefix}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}
