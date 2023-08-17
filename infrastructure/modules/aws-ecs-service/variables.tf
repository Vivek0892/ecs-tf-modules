variable "project" {
  description = "Name of the project."
}

variable "stack" {
  description = "Name of the stack."
}

variable "family" {
  description = "Family of the Task Definition"
  default     = "cloud-bootstrap"
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "stage" {}

variable "task_count" {
  description = "Number of ECS tasks to run"
  default     = 3
}
variable "alb_security_group_ids" {}
variable "aws_private_subnet_ids" {}
variable "aws_alb_trgp_id" {}
variable "ecs_cluster_id" {}
variable "vpc_main_id" {}
variable "ecs_taskdef_arn" {}

