# ---------------------------------------------------------------------------------------------------------------------
# ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.stack}-cluster-${var.stage}"
  setting {
   name  = "containerInsights"
   value = "enabled"
  }
  tags = {
    Name = "${var.stack}-cluster-${var.stage}"
    Project = var.project
    Stage = var.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS TASK DEFINITION USING FARGATE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "task-def" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.tasks-service-role.arn
  tags = {
    Name = "${var.stack}-ECS-Task-Def-${var.stage}"
    Project = var.project
    Stage = var.stage
  }
  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.image_repo_url}",
    "memory": ${var.fargate_memory},
    "name": "${var.family}",
    "networkMode": "awsvpc",
    "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${var.cw_log_group}",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "${var.cw_log_stream}"
            }
        },
    "environment": [],
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ]
  }
]
DEFINITION
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDWATCH LOG GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloud-bootstrap-cw-lgrp" {
  name = var.cw_log_group
  retention_in_days = 90
  tags = {
    Project = var.project
    Stage = var.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS TASK ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "tasks-service-role" {
  name = "${var.fargate-task-service-role}-ECSTasksServiceRole-${var.stage}"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.tasks-service-assume-policy.json
  tags = {
    Project = var.project
    Purpose = "tasks-service-role"
    Stage = var.stage
  }
}

data "aws_iam_policy_document" "tasks-service-assume-policy" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "tasks-service-role-attachment" {
  role = aws_iam_role.tasks-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}