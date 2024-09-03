locals {
  project_name = "ftiac"
}

module "networking" {
  source = "./modules/networking"
}

module "ec2_iam" {
  source = "./modules/iam"

  role_name          = "${var.environment}-${local.project_name}-role"
  role_description   = "Role for allowing the EC2 instances to interact with the S3 bucket and other AWS services securely"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  policy_names        = ["${var.environment}-${local.project_name}-ec2-policy"]
  policy_descriptions = ["Policy for allowing the EC2 instances to interact with the S3 bucket and other AWS services securely"]
  policy_documents    = [data.aws_iam_policy_document.ec2_s3_access.json]
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
  iam_role_name = module.ec2_iam.role_name
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  asg_name = "${var.environment}-${local.project_name}-asg"
  min_size = var.min_size
  max_size = var.max_size

  user_data = filebase64("./scripts/nginx.sh")

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
  db_sg_name           = "${var.environment}-${local.project_name}-db-sg"
  db_subnet_group_name = "${var.environment}-${local.project_name}-db-subnet-group"
  db_username          = "${local.project_name}User"

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
    }
  ]
}

module "storage" {
  source = "./modules/storage"

  bucket_name = "${var.environment}-${local.project_name}-bucket"
  acl         = "public-read"

  bucket_policy = data.aws_iam_policy_document.s3_read_access.json

  lifecycle_rules = var.lifecycle_rules
}
