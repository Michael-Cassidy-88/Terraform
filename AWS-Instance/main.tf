terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform_EC2"
  }
}