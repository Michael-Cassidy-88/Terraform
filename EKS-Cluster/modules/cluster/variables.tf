# --- cluster/variables.tf ---

variable "tags" {
  description = "aws-tags"
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "ec2_ssh_key" {}

variable "vpc_id" {}

variable "name" {}

variable "public_subnets" {}

variable "private_subnets" {}