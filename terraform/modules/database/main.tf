resource "aws_security_group" "main" {
  name   = var.db_sg_name
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
  username                    = var.db_username
  manage_master_user_password = var.manage_master_user_password
  parameter_group_name        = var.parameter_group_name
  publicly_accessible         = var.publicly_accessible
  skip_final_snapshot         = var.skip_final_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier
  vpc_security_group_ids      = [aws_security_group.main.id]
  multi_az                    = var.multi_az
  deletion_protection         = var.deletion_protection
  db_subnet_group_name        = aws_db_subnet_group.main.name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  blue_green_update {
    enabled = var.blue_green_update_enabled
  }

  tags = var.db_tags
}
