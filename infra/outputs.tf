# AWS region
output "aws_region" {
  description = "AWS region where Gatus is deployed"
  value       = var.aws_region
}

# VPC ID
output "vpc_id" {
  description = "ID of the Gatus VPC"
  value       = aws_vpc.main.id
}

# Public subnet IDs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# Private subnet IDs
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# ECR repository URL
output "ecr_repository_url" {
  description = "ECR repository URL for the Gatus Docker image"
  value       = aws_ecr_repository.gatus.repository_url
}

# ECS cluster name
output "ecs_cluster_name" {
  description = "Name of the Gatus ECS cluster"
  value       = aws_ecs_cluster.gatus.name
}

# ECS service name
output "ecs_service_name" {
  description = "Name of the Gatus ECS service"
  value       = aws_ecs_service.gatus.name
}

# Application Load Balancer DNS name
output "alb_dns_name" {
  description = "AWS-generated DNS address of the Application Load Balancer"
  value       = aws_lb.gatus.dns_name
}

# Initial HTTP website address
output "gatus_http_url" {
  description = "HTTP URL for testing Gatus before configuring a domain"
  value       = "http://${aws_lb.gatus.dns_name}"
}

# Future custom domain
output "gatus_domain_url" {
  description = "HTTPS URL when a custom domain is configured"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : null
}

# GitHub Actions ECR role
output "github_ecr_role_arn" {
  description = "IAM role ARN used by GitHub Actions to push Docker images"
  value       = aws_iam_role.github_ecr.arn
}

# GitHub Actions Terraform role
output "github_terraform_role_arn" {
  description = "IAM role ARN used by GitHub Actions for Terraform deployment"
  value       = aws_iam_role.github_terraform.arn
}
