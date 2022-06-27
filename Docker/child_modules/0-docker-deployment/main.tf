terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

resource "docker_image" "centos_image" {
  name = "centos:latest"
}

resource "docker_container" "centos_container" {
  count = var.container_count
  image = docker_image.centos_image.latest
  name  =  join("-", [var.name, random_string.random[count.index].result])
  start    = true
  command  = ["/bin/sleep", "1800"]
}

resource "random_string" "random" {
  count   = var.container_count
  length  = 4
  special = false
  upper   = false
}

resource "aws_ecr_repository" "docker-repo" {
  name  = "docker-repo"
}

resource "aws_ecr_repository_policy" "repo-policy" {
  repository = aws_ecr_repository.docker-repo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:*"
        ]
      }
    ]
  }
  EOF
}