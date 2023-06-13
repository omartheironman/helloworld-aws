terraform { 
  //Fetch the source of this module
  source = ""

}


include {
  path = find_in_parent_folders()

}

//Generate locals this will be used as injection in the inputs block below
locals {
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::072972537912:user/omar.moharrem"
      username = "omar.moharrem"
      groups   = ["system:masters"]
    }
  ]
}

//We input vpc_id, vpc_private_subnets from a dependency defined in dependency module
//We also input the local variable we define above
//Any inputs provided here are given to the module's defined variables
inputs = {

  vpc_id                   = dependency.vpc.outputs.vpc_id
  vpc_private_subnets      = dependency.vpc.outputs.private_subnets
  aws_auth_users           = local.aws_auth_users
}

//In here we define an explicit dependency terragrunt can find this output from the state file of this module
//When outputs are not present we have the option to mock it
dependency "vpc" {
  config_path = "../vpc"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs = {
        vpc_id              = "fake-vpc-id"
        private_subnets      = ["10.0.0.0/16"]
    }
}

