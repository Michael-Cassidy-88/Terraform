resource "aws_vpc" "ecs-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.tags
}

resource "aws_subnet" "ecs-public-subnet" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = var.tags
}

resource "aws_subnet" "ecs-public-subnet2" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = var.tags
}

resource "aws_internet_gateway" "ecs-ig" {
  vpc_id = aws_vpc.ecs-vpc.id

   tags = var.tags
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.ecs-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ecs-ig.id
    }

     tags = var.tags
}

resource "aws_route_table_association" "route_table_association" {
    route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.ecs-public-subnet.id
}

data "aws_ecr_repository" "docker-repo" {
  name = "docker-repo"
}

resource "aws_ecs_cluster" "docker-cluster" {
  name = "docker-cluster"

   tags = var.tags
}

resource "aws_ecs_service" "docker-service" {
  name            = "docker-service"
  cluster         = "${aws_ecs_cluster.docker-cluster.id}"
  task_definition = "${aws_ecs_task_definition.docker-task.arn}"
  launch_type     = "FARGATE"
  desired_count   = var.ecs_count

  network_configuration {
    subnets          = ["${aws_subnet.ecs-public-subnet.id}", "${aws_subnet.ecs-public-subnet2.id}"]
    assign_public_ip = true 
  }
}

resource "aws_ecs_task_definition" "docker-task" {
  family                   = "docker-task"
  container_definitions    = <<TASK_DEFINITION
  [
    {
      "name": "docker-task",
      "image": "${data.aws_ecr_repository.docker-repo.repository_url}:latest",
      "essential": true,
      "cpu": 512,
      "memory": 1024,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  TASK_DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

data "aws_iam_policy_document" "ecs-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}