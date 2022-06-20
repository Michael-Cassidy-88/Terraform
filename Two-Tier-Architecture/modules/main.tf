provider "aws" {
  region = var.region
}

resource "aws_vpc" "two-tier-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TTVPC"
  }
}

resource "aws_subnet" "two-tier-subnet-public-1" {
  vpc_id            = aws_vpc.two-tier-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Pub1"
  }
}

resource "aws_subnet" "two-tier-subnet-public-2" {
  vpc_id            = aws_vpc.two-tier-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Pub2"
  }
}

resource "aws_subnet" "two-tier-subnet-private-1" {
  vpc_id            = aws_vpc.two-tier-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Priv1"
  }
}

resource "aws_subnet" "two-tier-subnet-private-2" {
  vpc_id            = aws_vpc.two-tier-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Priv2"
  }
}

resource "aws_lb" "two-tier-lb" {
  load_balancer_type = "application"
  subnets            = [aws_subnet.two-tier-subnet-public-1.id, aws_subnet.two-tier-subnet-public-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "TTLB"
  }
}

resource "aws_internet_gateway" "two-tier-ig" {
  vpc_id = aws_vpc.two-tier-vpc.id
}

data "aws_ssm_parameter" "two-tier-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}