# Compute Module

The Compute module sets up the EC2 instances, Auto Scaling Group (ASG), and Application Load Balancer (ALB).

## Resources

- Launch Template
- Auto Scaling Group
- Application Load Balancer
- Target Group
- Listener
-  Security Groups

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables. Here is an example:

```
module "compute" {
source = "./modules/compute"
instance_type = "t3.micro"
min_size = 1
max_size = 3
desired_capacity = 2
alb_sg_name = "my-alb-sg"
instance_sg_name = "my-instance-sg"
alb_security_group_ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  instance_security_group_ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

## Outputs:

- alb_security_group_id: The ID of the ALB security group.
- instance_security_group_id: The ID of the EC2 instance security group.
- load_balancer_dns_name: The DNS name of the ALB.
- autoscaling_group_id: The ID of the Auto Scaling Group.
