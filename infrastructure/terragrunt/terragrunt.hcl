
//Define remote state
remote_state {
  //Ensure by default it init always happens
  disable_init = tobool(get_env("TERRAGRUNT_DISABLE_INIT", "false"))

  backend = "s3"
  //Generate backend.tf depending on which module terragrunt will execute (in our case there will be one for eks_cluster & vpc)
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    profile        = "ops" //This can be templated
    bucket         = "testbucket-ops" // This can be templated
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2" // This can be templated
    workspace_key_prefix = ""  
    }
}

//Dynamically generate a provider.tf(profile and region can be templated)
generate "provider" {
  path      = "provider.tf"
    if_exists = "overwrite_terragrunt"

  contents = <<EOF
    provider "aws" {
      region  = "us-west-2"
      profile = "ops"
    }
EOF
}

//We can pass a module TF vars in here we depend on environment variables
// i.e if we run TF_VAR_env=applications TF_VAR_team=ops-iac the tf var inside applications/ops-iac will be passed to the modules
// In here we set a default value for each environment variable infrastructure and be-iac respectively
terraform {
  extra_arguments "common_var" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/accounts/${get_env("TF_VAR_account", "backend")}/${get_env("TF_VAR_env", "dev")}.tfvars",
    ]

  }
}