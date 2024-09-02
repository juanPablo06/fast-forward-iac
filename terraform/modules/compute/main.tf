resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      from_port   = try(ingress.value.from_port, null)
      to_port     = try(ingress.value.to_port, null)
      protocol    = try(ingress.value.protocol, null)
      cidr_blocks = try(ingress.value.cidr_blocks, null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = try(egress.value.from_port, null)
      to_port     = try(egress.value.to_port, null)
      protocol    = try(egress.value.protocol, null)
      cidr_blocks = try(egress.value.cidr_blocks, null)
    }
  }

  tags = var.security_group_tags
}

resource "aws_lb" "main" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  client_keep_alive = var.client_keep_alive

  dynamic "access_logs" {
    for_each = var.access_logs
    content {
      bucket  = try(access_logs.value.bucket, null)
      prefix  = try(access_logs.value.prefix, null)
      enabled = try(access_logs.value.enabled, null)
    }
  }

  dynamic "connection_logs" {
    for_each = var.connection_logs
    content {
      bucket  = try(connection_logs.value.bucket, null)
      enabled = try(connection_logs.value.enabled, null)
      prefix  = try(connection_logs.value.prefix, null)
    }
  }

  tags = var.lb_tags
}

resource "aws_lb_target_group" "main" {
  name     = var.name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  dynamic "health_check" {
    for_each = var.health_check
    content {
      enabled             = try(health_check.value.enabled, null)
      interval            = try(health_check.value.interval, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      protocol            = try(health_check.value.protocol, null)
      timeout             = try(health_check.value.timeout, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
    }
  }

  tags = var.tg_tags
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.default_action_type
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_launch_template" "main" {
  name                   = var.name
  image_id               = var.image_id
  instance_type          = var.instance_type
  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.main.id]

  disable_api_stop        = var.disable_api_stop
  disable_api_termination = var.disable_api_termination

  ebs_optimized = var.ebs_optimized

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  monitoring {
    enabled = var.monitoring_enabled
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = try(block_device_mappings.value.device_name, null)
      no_device    = try(block_device_mappings.value.no_device, null)
      virtual_name = try(block_device_mappings.value.virtual_name, null)

      ebs {
        delete_on_termination = try(block_device_mappings.value.ebs.delete_on_termination, null)
        encrypted             = try(block_device_mappings.value.ebs.encrypted, null)
        iops                  = try(block_device_mappings.value.ebs.iops, null)
        kms_key_id            = try(block_device_mappings.value.ebs.kms_key_id, null)
      }
    }
  }

  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      associate_public_ip_address = try(network_interfaces.value.associate_public_ip_address, null)
      delete_on_termination       = try(network_interfaces.value.delete_on_termination, null)
      description                 = try(network_interfaces.value.description, null)
      device_index                = try(network_interfaces.value.device_index, null)
      network_interface_id        = try(network_interfaces.value.network_interface_id, null)
      private_ip_address          = try(network_interfaces.value.private_ip_address, null)
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = var.name
  vpc_zone_identifier       = var.subnets
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  termination_policies      = var.termination_policies
  target_group_arns         = [aws_lb_target_group.main.arn]

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  dynamic "tag" {
    for_each = var.asg_tags
    content {
      key                 = try(tag.value.key, null)
      value               = try(tag.value.value, null)
      propagate_at_launch = try(tag.value.propagate_at_launch, null)
    }
  }
}
