# ECS cluster for Gatus
resource "aws_ecs_cluster" "gatus" {
  name = "${local.name_prefix}-cluster"

  tags = {
    Name = "${local.name_prefix}-cluster"
  }
}

# CloudWatch log group for Gatus container logs
resource "aws_cloudwatch_log_group" "gatus" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = 7

  tags = {
    Name = "${local.name_prefix}-logs"
  }
}

# Define how ECS Fargate should run the Gatus container
resource "aws_ecs_task_definition" "gatus" {
  family                   = "${local.name_prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "gatus"
      image     = "${aws_ecr_repository.gatus.repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.gatus.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "gatus"
        }
      }
    }
  ])

  tags = {
    Name = "${local.name_prefix}-task"
  }
}

# Run Gatus using ECS Fargate
resource "aws_ecs_service" "gatus" {
  name            = "${local.name_prefix}-service"
  cluster         = aws_ecs_cluster.gatus.id
  task_definition = aws_ecs_task_definition.gatus.arn

  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.gatus.arn
    container_name   = "gatus"
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = 60

  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy_attachment.ecs_execution
  ]

  tags = {
    Name = "${local.name_prefix}-service"
  }
}
