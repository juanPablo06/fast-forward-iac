resource "aws_security_group" "alb" {
  name        = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = try(var.alb_security_group_ingress, [])
    content {
      description      = lookup(ingress.value, "description", "Managed by Terraform")
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      self             = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = try(var.alb_security_group_egress, [])
    content {
      description      = lookup(egress.value, "description", "Managed by Terraform")
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
    }
  }

  tags = var.security_group_tags
}

resource "aws_security_group" "ec2" {
  name        = var.instance_sg_name
  description = var.instance_sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = try(var.instance_security_group_ingress, [])
    content {
      description      = lookup(ingress.value, "description", "Managed by Terraform")
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      self             = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = try(var.instance_security_group_egress, [])
    content {
      description      = lookup(egress.value, "description", "Managed by Terraform")
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
    }
  }

  tags = var.security_group_tags
}

resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.alb_subnets

  enable_deletion_protection = var.enable_deletion_protection

  client_keep_alive = var.client_keep_alive

  dynamic "access_logs" {
    for_each = var.access_logs != null ? [var.access_logs] : []
    content {
      bucket  = access_logs.value.bucket
      prefix  = try(access_logs.value.prefix, "logs")
      enabled = try(access_logs.value.enabled, true)
    }
  }

  dynamic "connection_logs" {
    for_each = var.connection_logs != null ? [var.connection_logs] : []
    content {
      bucket  = connection_logs.value.bucket
      enabled = try(connection_logs.value.enabled, true)
      prefix  = try(connection_logs.value.prefix, "logs")
    }
  }

  tags = var.lb_tags
}

resource "aws_lb_target_group" "main" {
  name     = var.tg_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = var.health_check.enabled
    interval            = var.health_check.interval
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
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
  name                   = var.launch_template_name
  image_id               = var.image_id
  instance_type          = var.instance_type
  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.ec2.id]

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
    for_each = try(var.block_device_mappings, [])
    content {
      device_name  = try(block_device_mappings.value.device_name, "/dev/sda1")
      no_device    = try(block_device_mappings.value.no_device, null)
      virtual_name = try(block_device_mappings.value.virtual_name, null)

      ebs {
        delete_on_termination = try(block_device_mappings.value.ebs.delete_on_termination, true)
        encrypted             = try(block_device_mappings.value.ebs.encrypted, true)
        iops                  = try(block_device_mappings.value.ebs.iops, 100)
        kms_key_id            = try(block_device_mappings.value.ebs.kms_key_id, null)
      }
    }
  }

  dynamic "network_interfaces" {
    for_each = try(var.network_interfaces, [])
    content {
      associate_public_ip_address = try(network_interfaces.value.associate_public_ip_address, true)
      delete_on_termination       = try(network_interfaces.value.delete_on_termination, true)
      description                 = try(network_interfaces.value.description, null)
      device_index                = try(network_interfaces.value.device_index, 0)
      network_interface_id        = try(network_interfaces.value.network_interface_id, null)
      private_ip_address          = try(network_interfaces.value.private_ip_address, null)
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = var.asg_name
  vpc_zone_identifier       = var.asg_subnets
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
    for_each = try(var.asg_tags, [])
    content {
      key                 = try(tag.value.key, null)
      value               = try(tag.value.value, null)
      propagate_at_launch = try(tag.value.propagate_at_launch, true)
    }
  }
}

# policies to automatically scale up/down based on CPU utilization.
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-scale-up"
  scaling_adjustment     = var.scale_up_adjustment
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type

    }
    target_value = var.target_value
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project}-scale-down"
  scaling_adjustment     = var.scale_down_adjustment
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type

    }
    target_value = var.target_value
  }
}
