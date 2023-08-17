variable "project" {
  description = "Name of the project."
}

variable "stack" {
  description = "Name of the stack."
}

variable "vpc_main_id" {}
variable "aws_public_subnet_ids" {}
variable "stage" {}
variable "alb_target_group_id" {}