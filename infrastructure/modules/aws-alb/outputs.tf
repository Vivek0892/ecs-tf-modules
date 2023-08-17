output "alb_address" {
  value = aws_alb.alb.dns_name
}

output "alb_security_group_ids" {
  value = aws_security_group.alb-sg.id
}

output "alb_id" {
  value = aws_alb.alb.id
}