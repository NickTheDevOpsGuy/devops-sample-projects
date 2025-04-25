locals {
  common_tags = {
    environment = terraform.workspace
    owner       = "NickTheDevOpsGuy"
    project     = "terraform-azure-lab"
  }
}