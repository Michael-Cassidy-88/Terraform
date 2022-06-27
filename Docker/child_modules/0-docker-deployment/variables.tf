variable "image" {
  description = "image for container"
  default     = "centos_image.latest"
}

variable "name" {
    type = string 
    description = "name of container"
}

variable "container_count" {
    type = number
    default = 2
}