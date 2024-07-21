provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "devsutest" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

output "repository_url" {
  value = aws_ecr_repository.devsutest.repository_url
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# Crear una definición de tarea
resource "aws_ecs_task_definition" "task_definition_demostracion" {
  family                   = var.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  
  container_definitions = jsonencode([
    {
      name  = var.container-demostracion-devops
      image = var.container_image
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
}

# Crear un servicio ECS
resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = [aws_subnet.my_subnet.id]
    security_groups = [aws_security_group.my_security_group.id]
  }
}

# Crear un VPC para el clúster ECS
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Crear una subred para el clúster ECS
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

# Crear un grupo de seguridad para el clúster ECS
resource "aws_security_group" "my_security_group" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}