# --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "tags" {
  description = "aws-tags"
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "availabilityzone" {}

variable "azs" {}