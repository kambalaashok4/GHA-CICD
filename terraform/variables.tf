variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name used to name resources"
  type        = string
  default     = "django-app"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "task_cpu" {
  description = "CPU units for the ECS task (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MiB) for the ECS task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "ecr_image_tag" {
  description = "Docker image tag to deploy (set by CI/CD pipeline)"
  type        = string
  default     = "latest"
}

variable "django_secret_key" {
  description = "Django SECRET_KEY value"
  type        = string
  sensitive   = true
}
