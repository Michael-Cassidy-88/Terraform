output "PrivateIP" {
  description = "Private IP of EC2 instance"
  value       = aws_instance.two-tier-instance1.private_ip
}

output "PrivateIP2" {
  description = "Private IP of EC2 instance"
  value       = aws_instance.two-tier-instance2.private_ip
}