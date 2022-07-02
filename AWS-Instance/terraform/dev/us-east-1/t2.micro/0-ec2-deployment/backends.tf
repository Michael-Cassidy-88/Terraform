# --- root/backends.tf ---

terraform {
  cloud {
    organization = "Michael-Cassidy"

    workspaces {
      name = "aws-instance"
    }
  }
}