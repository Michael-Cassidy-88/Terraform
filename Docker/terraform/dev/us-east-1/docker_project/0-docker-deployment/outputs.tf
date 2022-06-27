output "container-name" {
  value       = module.image[*].container-name
  description = "The name of the container."
}

output "image-name" {
  value = module.image.image-name
}