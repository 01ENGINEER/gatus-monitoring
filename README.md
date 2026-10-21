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

Current structure:

```text
gatus-monitoring/
├── Dockerfile
├── config.yaml
└── README.md
```

Planned additions include Terraform infrastructure files, GitHub Actions workflows, and architecture documentation.

## Gatus Configuration

Gatus is configured using `config.yaml`.

The initial configuration monitors Google every 30 seconds and considers the endpoint healthy when it returns HTTP status code 200.

```yaml
endpoints:
  - name: Google
    url: "https://www.google.com"
    interval: 30s
    conditions:
      - "[STATUS] == 200"
```

## Local Docker Setup

### Prerequisites

- Docker installed and running
- Git
- A terminal

### Build the Docker Image

From the project directory:

```bash
docker build -t gatus-monitoring:v1 .
```

### Run the Container

```bash
docker run --name gatus-project -p 8080:8080 gatus-monitoring:v1
```

### Access the Dashboard

Open:

http://localhost:8080

The Gatus dashboard displays the configured monitoring endpoint and its health status.

### Stop the Container

Press `Ctrl + C` in the terminal running the container.

To restart an existing stopped container:

```bash
docker start -a gatus-project
```

## Progress

### Completed

- [x] Designed the AWS architecture.
- [x] Created the Gatus configuration.
- [x] Installed and verified Docker.
- [x] Tested Gatus locally using the upstream Docker image.
- [x] Created a custom multi-stage Dockerfile.
- [x] Built a custom Gatus Docker image.
- [x] Created the GitHub repository and pushed the initial project files.

### Remaining

- [ ] Revalidate the custom Docker image and its runtime configuration.
- [ ] Create and push the container image to Amazon ECR.
- [ ] Deploy Gatus manually to ECS Fargate.
- [ ] Configure the Application Load Balancer and health checks.
- [ ] Configure Route 53, ACM and HTTPS.
- [ ] Recreate the infrastructure using Terraform.
- [ ] Configure GitHub Actions authentication using OIDC.
- [ ] Automate image builds and infrastructure deployment.
- [ ] Validate the deployed `/health` endpoint.
- [ ] Add deployment screenshots and final architecture documentation.

## Security Considerations

The project aims to follow cloud security best practices, including:

- Running the application as a non-root container user.
- Deploying ECS tasks in private subnets.
- Restricting application traffic through security groups.
- Using HTTPS for external access.
- Using GitHub OIDC instead of long-lived AWS access keys.
- Using IAM roles with least-privilege permissions.
- Encrypting container images at rest in Amazon ECR.

## CI/CD Plan

The planned GitHub Actions workflows will:

1. Build and validate the Docker image.
2. Push the versioned image to Amazon ECR.
3. Run Terraform validation, planning, and deployment.
4. Deploy or update the ECS Fargate service.
5. Verify application health after deployment.

## Project Status

**In progress — local development and initial GitHub setup completed. AWS deployment and CI/CD automation are pending.**



