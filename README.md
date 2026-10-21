# Gatus Monitoring Platform on AWS ECS Fargate

## Project Overview

This project demonstrates the deployment of a containerised Gatus monitoring application on AWS using Docker, Amazon ECR, ECS Fargate, Terraform, GitHub Actions, and OpenID Connect (OIDC).

The goal is to build a secure, highly available, automated cloud deployment with HTTPS, infrastructure as code, and continuous integration and deployment.

The project is being developed in stages, starting with local Docker testing before progressing to AWS deployment and CI/CD automation.

## Technology Stack

| Technology | Purpose |
|---|---|
| Gatus | Monitoring application and dashboard |
| Docker | Containerisation |
| Amazon ECR | Container image registry |
| Amazon ECS Fargate | Serverless container hosting |
| Application Load Balancer | Distributes incoming application traffic |
| Amazon VPC | Network isolation and connectivity |
| Route 53 | DNS and custom domain |
| AWS Certificate Manager | HTTPS/TLS certificates |
| Terraform | Infrastructure as Code |
| GitHub Actions | CI/CD automation |
| GitHub OIDC + AWS IAM | Secure authentication without long-lived AWS keys |
| Amazon CloudWatch | Logs and infrastructure monitoring |

## Architecture

The planned AWS architecture includes:

- A VPC spanning two Availability Zones.
- Public subnets for an internet-facing Application Load Balancer and NAT Gateways.
- Private subnets for Gatus containers running on ECS Fargate.
- Amazon ECR for storing container images.
- Route 53 and AWS Certificate Manager for DNS and HTTPS.
- CloudWatch for application logs and infrastructure monitoring.
- GitHub Actions for automated Docker builds and Terraform deployments using OIDC.

An architecture diagram will be added to this repository.

## Project Structure

Current
