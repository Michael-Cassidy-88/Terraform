output "subnet_id1" {
  value = aws_subnet.ecs-public-subnet.id
}

output "subnet_id2" {
  value = aws_subnet.ecs-public-subnet2.id
}

output "vpc_id" {
    value = aws_vpc.ecs-vpc.id
}