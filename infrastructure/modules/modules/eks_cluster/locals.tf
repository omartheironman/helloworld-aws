locals {
  prefix = "${var.project}-${var.environment}"

  //Define our auth users list to be used in the eks module here
  #   devops_aws_auth_users = [
  #     for username in module.devops-users.user_list : {
  #       userarn  = "arn:aws:iam::${var.account_id}:user/${username}"
  #       username = username
  #       groups   = ["system:masters"]
  #     }
  #   ]

}
