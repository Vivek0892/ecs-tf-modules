output "ecs_task_execution_role_arn_prod" {
  value = module.aws-ecs-td-cloudwtchgrp-taskrole-prod.ecs_task_execution_role_arn
}

output "alb_address_prod" {
  value = module.blue-green-alb-trgt-grp-prod.alb_address
}