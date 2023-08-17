# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP FOR ECS TASKS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "task-sg" {
  name        = "${var.stack}-task-sg-${var.stage}"
  description = "Allow inbound access to ECS tasks from the ALB only"
  vpc_id      = var.vpc_main_id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [var.alb_security_group_ids]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.stack}-task-sg-${var.stage}"
    Project = var.project
    Stage = var.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "service" {
  name            = "${var.stack}-service-${var.stage}"
  cluster         = var.ecs_cluster_id
  task_definition = var.ecs_taskdef_arn
  desired_count   = var.task_count
  launch_type     = "FARGATE"
  tags = {
    Name = "${var.stack}-ECS-service-${var.stage}"
    Project = var.project
    Stage = var.stage
  }

  network_configuration {
    security_groups = [aws_security_group.task-sg.id]
    subnets         = var.aws_private_subnet_ids
  }

  load_balancer {
    target_group_arn = var.aws_alb_trgp_id
    container_name   = var.family
    container_port   = var.container_port
  }
}