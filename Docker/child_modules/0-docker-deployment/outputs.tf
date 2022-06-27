output "container-name" {
  value       = docker_container.centos_container[*].name
  description = "The name of the container."
}

output "image-name" {
  value = docker_image.centos_image.latest
}