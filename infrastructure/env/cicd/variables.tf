variable "project" {
  description = "Name of the project."
  default     = "cc-cloud-bootstrap"
}

variable "stack" {
  description = "Name of the stack."
  default     = "CloudBootstrap"
}


variable "aws_region" {
  description = "The AWS region to create things in."
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "family" {
  description = "Family of the Task Definition"
  default = "cloud-bootstrap"
}

# Source repo name and branch
variable "source_repo_name" {
  description = "Source repo name"
  type = string
}

variable "source_repo_branch" {
  description = "Source repo branch"
  type = string
}

# Image repo name for ECR
variable "image_repo_name" {
  description = "Image repo name"
  type = string
}

variable "ecs_cluster_name_dev"{
    default = "cloud-bootstrap-cluster-dev"
}
variable "ecs_service_name_dev"{
    default = "cloud-bootstrap-service-dev"
}
variable "codedeploy_deployment_group_name"{
  default = "cc-cloud-bootstrap-prod-deployment-group"
}
variable "codedeploy_application_name"{
  default = "cc-cloud-bootstrap-prod-app"
}