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
    key = "ecs_ecr_vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# DEV stage
module "aws_vpc-dev" {
  source = "../../modules/aws_vpc"
  stage = "dev"
  project = var.project
  stack = var.stack
  az_count = var.az_count_dev
  vpc_cidr = var.vpc_cidr_dev
}
module "aws-alb-trgt-grp-dev" {
  source = "../../modules/aws-alb-trgt-grp"
  stage = "dev"
  project = var.project
  stack = var.stack
  vpc_main_id = module.aws_vpc-dev.vpc_main_id
}

module "aws-alb-dev" {
  source = "../../modules/aws-alb"
  stage = "dev"
  vpc_main_id = module.aws_vpc-dev.vpc_main_id
  aws_public_subnet_ids = module.aws_vpc-dev.vpc_public_subnet_ids
  alb_target_group_id = module.aws-alb-trgt-grp-dev.alb_target_group_id
  project = var.project
  stack = var.stack
}

module "aws-ecs-td-cloudwtchgrp-taskrole-dev" {
  source = "../../modules/aws-ecs-td-cloudwtchgrp-taskrole"
  stage = "dev"
  depends_on = [module.aws-alb-dev.alb_security_group_ids]
  project = var.project
  stack = var.stack
  aws_region = var.aws_region
  fargate-task-service-role = var.fargate-task-service-role-dev
  vpc_main_id = module.aws_vpc-dev.vpc_main_id
  cw_log_group = "${var.project}-dev"
  image_repo_url = var.image_repo_url
}

module "aws-ecs-service-dev" {
  source = "../../modules/aws-ecs-service"
  stage = "dev"
  project = var.project
  stack = var.stack
  aws_private_subnet_ids = module.aws_vpc-dev.vpc_private_subnet_ids
  ecs_cluster_id = module.aws-ecs-td-cloudwtchgrp-taskrole-dev.ecs_cluster_id
  vpc_main_id = module.aws_vpc-dev.vpc_main_id
  alb_security_group_ids = module.aws-alb-dev.alb_security_group_ids
  aws_alb_trgp_id = module.aws-alb-trgt-grp-dev.alb_target_group_id
  ecs_taskdef_arn = module.aws-ecs-td-cloudwtchgrp-taskrole-dev.ecs_taskdef_arn
}

