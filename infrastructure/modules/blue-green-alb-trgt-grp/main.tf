
# ---------------------------------------------------------------------------------------------------------------------
# ALB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb" "alb" {
  name = "${var.stack}-alb-${var.stage}"
  subnets = var.aws_public_subnet_ids
  security_groups = [aws_security_group.alb-sg-bg.id]
   tags = {
    Name = "${var.stack}-ALB-${var.stage}"
    Project = var.project
    Stage = var.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB TARGET GROUPS (WE NEED 2 FOR BLUE/GREEN DEPLOYMENT)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_target_group" "trgp-blue" {
  name = "${var.stack}-tgrp-blue-${var.stage}"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_main_id
  target_type = "ip"
  health_check {
    path = "/actuator/health"
    port = 8080
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 3
    interval = 8
    matcher = "200"
  }
  tags = {
    Project = var.project
    Stage = var.stage
  }
}

resource "aws_alb_target_group" "trgp-green" {
  name = "${var.stack}-tgrp-green-${var.stage}"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_main_id
  target_type = "ip"
  health_check {
    path = "/actuator/health"
    port = 8080
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 3
    interval = 8
    matcher = "200"
  }
  tags = {
    Project = var.project
    Stage = var.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB LISTENER - INITIALLY ROUTE TO THE BLUE GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.alb.id
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.trgp-blue.id
    type = "forward"
  }
  tags = {
    Project = var.project
    Stage = var.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP FOR ALB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "alb-sg-bg" {
  name        = "${var.stack}-alb-sg-${var.stage}"
  description = "ALB Security Group"
  vpc_id      = var.vpc_main_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.stack}-alb-sg-${var.stage}"
    Project = var.project
    Stage = var.stage
  }
}