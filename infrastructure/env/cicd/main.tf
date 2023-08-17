# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER FOR TF CLOUD
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    # Setting variables in the backend section isn't possible as of now, see https://github.com/hashicorp/terraform/issues/13022
    bucket = "tf-backend-state-ecs-urolime-demo-2023"
    encrypt = true
    dynamodb_table = "tf-backend-lock-ecs-urolime-demo-2023"
    key = "cicd/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# Shared CI/CD infrastructure
module "aws-cicd-all" {
  source = "../../modules/aws-cicd"
  project = var.project
  stack = var.stack
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  image_repo_name = var.image_repo_name
  source_repo_branch = var.source_repo_branch
  source_repo_name = var.source_repo_name
  family = var.family
  ecs_cluster_name_dev = var.ecs_cluster_name_dev
  ecs_service_name_dev = var.ecs_service_name_dev
  codedeploy_application_name = var.codedeploy_application_name
  codedeploy_deployment_group_name = var.codedeploy_deployment_group_name
}