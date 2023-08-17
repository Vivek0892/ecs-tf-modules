# ---------------------------------------------------------------------------------------------------------------------
# ALB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb" "alb" {
  name = "${var.stack}-alb-${var.stage}"
  subnets = var.aws_public_subnet_ids
  security_groups = [aws_security_group.alb-sg.id]
  tags = {
    Name = "${var.stack}-ALB-${var.stage}"
    Project = var.project
    Stage = var.stage
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# ALB LISTENER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.alb.id
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = var.alb_target_group_id
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

resource "aws_security_group" "alb-sg" {
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
