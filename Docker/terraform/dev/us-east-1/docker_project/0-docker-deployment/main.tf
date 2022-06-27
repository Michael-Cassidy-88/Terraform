terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

locals {
  cwd         = reverse(split("/", path.cwd))
  name        = local.cwd[1]
  environment = local.cwd[3]
  location    = local.cwd[2]
}

module "image" {
  source = "../../../../../child_modules/0-docker-deployment"
  name   = local.name
}