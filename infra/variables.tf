variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Name used for AWS resources"
  type        = string
  default     = "gatus-monitoring"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "container_port" {
  description = "Port used by the Gatus application"
  type        = number
  default     = 8080
}

variable "domain_name" {
  description = "Optional domain name for HTTPS"
  type        = string
  default     = ""
}

variable "image_tag" {
  description = "Docker image tag deployed to ECS"
  type        = string
  default     = "bootstrap"
}
