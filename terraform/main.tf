locals {
  project_name = "ftiac"
}

module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"

  vpc_id                  = module.networking.vpc_id
  alb_subnets             = module.networking.public_subnet_ids
  asg_subnets             = module.networking.private_subnet_ids
  instance_sg_name        = "${var.environment}-${local.project_name}-instance-sg"
  instance_sg_description = "Security group for EC2 instances"
  alb_sg_name             = "${var.environment}-${local.project_name}-alb-sg"
  alb_sg_description      = "Security group for ALB"

  alb_name             = "${var.environment}-${local.project_name}-alb"
  tg_name              = "${var.environment}-${local.project_name}-tg"
  launch_template_name = "${var.environment}-${local.project_name}-lt"

  project       = local.project_name
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  asg_name         = "${var.environment}-${local.project_name}-asg"
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  alb_security_group_ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  alb_security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  instance_security_group_ingress = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.compute.alb_security_group_id]
    }
  ]

  instance_security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


module "database" {
  source = "./modules/database"

  vpc_id               = module.networking.vpc_id
  db_instance_name     = "${var.environment}-${local.project_name}-db"
  db_name              = local.project_name
  parameter_group_name = "${local.project_name}-pg"
  db_sg_name           = "${var.environment}-${local.project_name}-db-sg"
  db_subnet_group_name = "${var.environment}-${local.project_name}-db-subnet-group"

  final_snapshot_identifier = "${var.environment}-${local.project_name}-snapshot"
  multi_az                  = true
  subnet_ids                = module.networking.private_subnet_ids

  security_group_ingress = [
    {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.compute.instance_security_group_id]
    }
  ]

  security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }]
}

module "storage" {
  source = "./modules/storage"

  bucket_name = "${var.environment}-${local.project_name}-bucket"
  acl         = "public-read"

  bucket_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${var.environment}-${local.project_name}-bucket/*"
      }
    ]
  })

  lifecycle_rules = [
    {
      id     = "OldVersions",
      status = "Enabled",
      filter = [
        {
          prefix = ""
        }
      ]

      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
      ]

      noncurrent_version_transition = [
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]

      noncurrent_version_expiration = [
        {
          days = 90
        }
      ]
    }
  ]

}
