resource "aws_security_group" "main" {
  name   = var.db_sg_name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
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
    for_each = var.security_group_egress
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

resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.db_subnet_group_tags
}

resource "aws_db_instance" "main" {
  identifier                  = var.db_instance_name
  allocated_storage           = var.allocated_storage
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  db_subnet_group_name        = aws_db_subnet_group.main.name
  username                    = var.db_username
  manage_master_user_password = var.manage_master_user_password
  publicly_accessible         = var.publicly_accessible
  skip_final_snapshot         = var.skip_final_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier
  vpc_security_group_ids      = [aws_security_group.main.id]
  multi_az                    = var.multi_az
  deletion_protection         = var.deletion_protection

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  blue_green_update {
    enabled = var.blue_green_update_enabled
  }

  tags = var.db_tags
}
