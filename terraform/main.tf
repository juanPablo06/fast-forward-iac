locals {
  project_name = "ftiac"
}

module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"

  vpc_id                  = module.networking.vpc_id
  subnets                 = module.networking.public_subnet_ids
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
