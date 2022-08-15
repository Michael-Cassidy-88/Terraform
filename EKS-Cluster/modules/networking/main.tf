# --- networking/main.tf ---


### VPC CONFIGURATION

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks_vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "available" {
}

### INTERNET GATEWAY

resource "aws_internet_gateway" "eks_internet_gateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}


### PUBLIC SUBNETS AND ASSOCIATED ROUTE TABLES

resource "aws_subnet" "eks_public_subnets" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.123.${10 + count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                       = "eks_public_${count.index + 1}"
    "kubernetes.io/cluster/eks-public-cluster" = "shared"
    "kubernetes.io/role/elb"                   = 1
  }
}

resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.eks_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_internet_gateway.id
}

resource "aws_route_table_association" "eks_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.eks_public_subnets.*.id[count.index]
  route_table_id = aws_route_table.eks_public_rt.id
}


### EIP AND NAT GATEWAY

resource "aws_eip" "eks_nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "eks_ngw" {
  allocation_id = aws_eip.eks_nat_eip.id
  subnet_id     = aws_subnet.eks_public_subnets[0].id
}


### PRIVATE SUBNETS AND ASSOCIATED ROUTE TABLES

resource "aws_subnet" "eks_private_subnets" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.123.${20 + count.index}.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                        = "eks_private_${count.index + 1}"
    "kubernetes.io/cluster/eks-private-cluster" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

resource "aws_route" "default_private_route" {
  route_table_id         = aws_route_table.eks_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_ngw.id
}


resource "aws_route_table_association" "eks_private_assoc" {
  count          = var.private_sn_count
  route_table_id = aws_route_table.eks_private_rt.id
  subnet_id      = aws_subnet.eks_private_subnets.*.id[count.index]
}