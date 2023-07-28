output "atlantis_infra_provisioning_role_arn" {
  value = aws_iam_role.atlantis-infra-provisioning-role.arn
}

output "atlantis_infra_provisioning_role_name" {
  value = aws_iam_role.atlantis-infra-provisioning-role.name
}
