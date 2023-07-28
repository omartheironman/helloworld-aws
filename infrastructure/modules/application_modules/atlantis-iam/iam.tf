
// Create Role for atlantis to provision infrastructure
resource "aws_iam_role" "atlantis-infra-provisioning-role" {
  name = "atlantis-${var.environment_shortname}-infra-provisioning-role"

  assume_role_policy = jsonencode({
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_id}:role/${var.atlantis_role}"
        }
      }
    ],
    "Version" : "2012-10-17"
  })
  tags = {
    role = "atlantis"
  }
}

resource "aws_iam_policy" "atlantis-policy" {
  name        = "atlantis-policy"
  description = "Policies required by the Atlantis to provision infra"
  path        = "/"
  policy      = data.aws_iam_policy_document.atlantis.json
}

//Attach a policy to the infrastructure provisioning role
resource "aws_iam_role_policy_attachment" "backend-terraform-state" {
  role       = aws_iam_role.atlantis-infra-provisioning-role.name
  policy_arn = aws_iam_policy.atlantis-policy.arn
}
