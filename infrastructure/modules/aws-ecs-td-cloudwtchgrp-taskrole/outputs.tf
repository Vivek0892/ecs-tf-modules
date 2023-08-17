output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "ecs_task_execution_role_arn" {
  value = aws_ecs_task_definition.task-def.execution_role_arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs-cluster.id
}

output "ecs_taskdef_arn" {
  value = aws_ecs_task_definition.task-def.arn
}
