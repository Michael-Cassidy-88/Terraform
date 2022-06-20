output "subnet_id1" {
  value = aws_subnet.two-tier-subnet-public-1.id
}

output "subnet_id2" {
  value = aws_subnet.two-tier-subnet-public-2.id
}

output "subnet_id3" {
  value = aws_subnet.two-tier-subnet-private-1.id
}

output "subnet_id4" {
  value = aws_subnet.two-tier-subnet-private-2.id
}

output "ami_id" {
  value = data.aws_ssm_parameter.two-tier-ami.value
}