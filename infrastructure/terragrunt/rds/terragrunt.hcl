# terragrunt.hcl

terraform {
  source = ""
}

include "root" {
  path = find_in_parent_folders()
}

//In here we define an explicit dependency terragrunt can find this output from the state file of this module
//When outputs are not present we have the option to mock it
dependency "vpc" {
  config_path = "../vpc"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs = {
      vpc_id                     = "fake-vpc-id"
      private_subnets            = ["10.0.0.0/16"]
      vpc_database_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
      vpc_database_subnet_groups = ["database-subnet-group-1", "database-subnet-group-2"]
      vpc_cidr_block                   = "10.0.0.0/16"
    }
}

inputs = {
    vpc_id                   = dependency.vpc.outputs.vpc_id
    vpc_cidr      = dependency.vpc.outputs.vpc_cidr_block
    vpc_database_subnet_group      = dependency.vpc.outputs.vpc_database_subnet_groups
    project = "dev"
}