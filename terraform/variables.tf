variable "region" {
  description = "us east"
  default     = "us-east-1"
}

variable "repository_name" {
  description = "El nombre del repositorio de ECR"
  default     = "devsutest"
}

variable "cluster_name" {
  description = "El nombre del clúster ECS"
  default     = "demostracion-devops-ecs-cluster"
}

variable "service_name" {
  description = "El nombre del servicio ECS"
  default     = "demostracion-devops-ecs-service"
}

variable "task_definition_demostracion" {
  description = "tarea demostracion devops"
  default     = "demostracion-devops-task-definition"
}

variable "container-demostracion-devops" {
  description = "El nombre del contenedor"
  default     = "demostracion-devops"
}

variable "container_image" {
  description = "La imagen del contenedor"
  default     = "nginx:latest"
}

variable "container_port" {
  description = "El puerto del contenedor"
  default     = 80
}