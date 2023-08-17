# ---------------------------------------------------------------------------------------------------------------------
# ALB TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_target_group" "trgp" {
  name = "${var.stack}-tgrp-${var.stage}"
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