variable "location" {
  type    = string
}

variable "name" {
  type = string
  description = "vpc name"
}

variable "tags" {
  description = "aws-tags"
}

variable "ecs_count" {
    type = number
    default = 2
}