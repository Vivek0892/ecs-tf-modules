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
    key = "ecs_ecr_prod/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}


# prod stage
module "aws_vpc-prod" {
  source = "../../modules/aws_vpc"
  stage = "prod"
  project = var.project
  stack = var.stack
  az_count = var.az_count_prod
  vpc_cidr = var.vpc_cidr_prod
}
module "blue-green-alb-trgt-grp-prod" {
  source = "../../modules/blue-green-alb-trgt-grp"
  stage = "prod"
  project = var.project
  stack = var.stack
  vpc_main_id = module.aws_vpc-prod.vpc_main_id
  aws_public_subnet_ids = module.aws_vpc-prod.vpc_public_subnet_ids
}
module "aws-ecs-td-cloudwtchgrp-taskrole-prod" {
  source = "../../modules/aws-ecs-td-cloudwtchgrp-taskrole"
  stage = "prod"
  depends_on = [module.blue-green-alb-trgt-grp-prod.alb_security_group_ids]
  project = var.project
  stack = var.stack
  aws_region = var.aws_region
  fargate-task-service-role = var.fargate-task-service-role-prod
  vpc_main_id = module.aws_vpc-prod.vpc_main_id
  cw_log_group = "${var.project}-prod"
  image_repo_url = var.image_repo_url
}

module "aws-blue-green-resource-prod" {
  source = "../../modules/aws-blue-green-resource"
  stage = "prod"
  project = var.project
  stack = var.stack
  aws_private_subnet_ids = module.aws_vpc-prod.vpc_private_subnet_ids
  ecs_cluster_id = module.aws-ecs-td-cloudwtchgrp-taskrole-prod.ecs_cluster_id
  ecs_cluster_name = module.aws-ecs-td-cloudwtchgrp-taskrole-prod.ecs_cluster_name
  vpc_main_id = module.aws_vpc-prod.vpc_main_id
  fargate-task-service-role = var.fargate-task-service-role-prod
  aws_alb_security_group_ids = module.blue-green-alb-trgt-grp-prod.alb_security_group_ids
  aws_alb_trgp_blue_id = module.blue-green-alb-trgt-grp-prod.alb_target_group_blue_id
  aws_alb_listener_arn = module.blue-green-alb-trgt-grp-prod.alb_listener_arn
  aws_alb_trgp_blue_name = module.blue-green-alb-trgt-grp-prod.alb_target_group_blue_name
  aws_alb_trgp_green_id = module.blue-green-alb-trgt-grp-prod.alb_target_group_green_id
  aws_alb_trgp_green_name = module.blue-green-alb-trgt-grp-prod.alb_target_group_green_name
  ecs_taskdef_arn = module.aws-ecs-td-cloudwtchgrp-taskrole-prod.ecs_taskdef_arn
}

