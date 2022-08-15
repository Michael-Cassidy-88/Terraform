# --- root/outputs.tf ---

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.cluster.cluster_endpoint
}