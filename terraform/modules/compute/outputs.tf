output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_security_group_arn" {
  value = aws_security_group.alb.arn
}

output "instance_security_group_id" {
  value = aws_security_group.ec2.id
}

output "instance_security_group_arn" {
  value = aws_security_group.ec2.arn
}

output "load_balancer_arn" {
  value = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.main.arn_suffix
}

output "listener_arn" {
  value = aws_lb_listener.main.arn
}

output "launch_template_id" {
  value = aws_launch_template.main.id
}

output "launch_template_arn" {
  value = aws_launch_template.main.arn
}

output "launch_template_latest_version" {
  value = aws_launch_template.main.latest_version
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.main.id
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.main.arn
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.main.name
}
