output "ecs_task_execution_role_arn_dev" {
  value = module.aws-ecs-td-cloudwtchgrp-taskrole-dev.ecs_task_execution_role_arn
}

output "alb_address_dev" {
  value = module.aws-alb-dev.alb_address
}

output "ecs_cluster_name" {
  value = module.aws-ecs-td-cloudwtchgrp-taskrole-dev.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.aws-ecs-service-dev.ecs_service_name
}