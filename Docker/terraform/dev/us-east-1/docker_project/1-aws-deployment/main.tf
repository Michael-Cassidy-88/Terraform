provider "aws" {
  region = local.location
}

locals {
  cwd         = reverse(split("/", path.cwd))
  name        = local.cwd[1]
  environment = local.cwd[3]
  location    = local.cwd[2]

  tags = {
    project     = "docker_project"
    environment = "dev"
    managedby   = "terraform"
    owner       = "Michael-Cassidy"
  }
}

module "vpc" {
  source   = "../../../../../child_modules/1-aws-deployment"
  name     = "${local.name}-vpc"
  location = local.location
  tags     = local.tags
}