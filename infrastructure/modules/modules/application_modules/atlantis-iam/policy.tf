data "aws_iam_policy_document" "atlantis" {
  statement {
    sid = "FullAccess"

    actions = [
      "access-analyzer:*",
      "autoscaling:*",
      "cloudfront:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "codeartifact:*",
      "compute-optimizer:*",
      "cloudformation:*",
      "ec2:*",
      "ecr:*",
      "eks:*",
      "elasticfilesystem:*",
      "elasticloadbalancing:*",
      "glacier:*",
      "iam:*",
      "kms:*",
      "logs:*",
      "organizations:*",
      "ram:*",
      "rds:*",
      "route53:*",
      "route53domains:*",
      "s3:*",
      "secretsmanager:*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "EKSPassRole"

    actions = ["iam:PassRole"]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = ["eks.amazonaws.com"]
    }
  }
  statement {
    sid = "DenyDeletion"

    actions = [
      "eks:Delete*",
      "rds:Delete*",
      "rds:Delete*",
      "ecr:Delete*",
      "route53:Delete*",
      "kms:Delete*"
    ]

    resources = ["*"]
    effect    = "Deny"
  }
}
