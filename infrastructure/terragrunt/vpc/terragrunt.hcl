terraform {
  source = ""

  //Ensure we are in ops workspace before running any of these commands
  before_hook "workspace" {
    commands     = ["plan","destroy","destroy"]
    execute      = ["terraform", "workspace", "select", "ops"]
  }

}

include "root" {
  path = find_in_parent_folders()
}

//Not needed this can be neglected as we dont use it in inputs for now
locals {
  prefix = "be-development"
}