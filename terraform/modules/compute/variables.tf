# Security Group Variables

variable "instance_sg_name" {
  description = "The name of the instance security group"
  type        = string
}

variable "alb_sg_name" {
  description = "The name of the instance security group"
  type        = string
}

variable "instance_sg_description" {
  description = "The description of the instance security group"
  type        = string
}

variable "alb_sg_description" {
  description = "The description of the instance security group"
  type        = string
}

variable "alb_security_group_ingress" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  default = []
}

variable "alb_security_group_egress" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  default = []
}

variable "instance_security_group_ingress" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  default = []
}

variable "instance_security_group_egress" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  default = []
}

variable "security_group_tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}

# Load Balancer Variables
variable "alb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "alb_subnets" {
  description = "List of subnet IDs to attach to the load balancer"
  type        = list(string)
  default     = []
}

variable "internal" {
  description = "Whether the load balancer is internal or external"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "The type of load balancer (e.g., application, network)"
  type        = string
  default     = "application"
}

variable "subnets" {
  description = "List of subnet IDs to attach to the load balancer"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "client_keep_alive" {
  description = "The time in seconds that the connection is allowed to be idle (keep-alive) before it is closed by the load balancer"
  type        = number
  default     = 3600
}

variable "access_logs" {
  description = "Configuration for access logs"
  type = object({
    bucket  = string
    prefix  = string
    enabled = bool
  })
  default = null
}

variable "connection_logs" {
  description = "Configuration for connection logs"
  type = object({
    bucket  = string
    prefix  = string
    enabled = bool
  })
  default = null
}

variable "lb_tags" {
  description = "Tags to apply to the load balancer"
  type        = map(string)
  default     = {}
}

# Target Group Variables
variable "tg_name" {
  description = "The name of the target group"
  type        = string
}

variable "port" {
  description = "The port on which the target group listens"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "The protocol used by the target group (e.g., HTTP, HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "The ID of the VPC for the target group"
  type        = string
}

variable "health_check" {
  description = "Configuration for health checks"
  type = object({
    enabled             = bool
    interval            = number
    path                = string
    port                = string
    protocol            = string
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
  default = {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

variable "tg_tags" {
  description = "Tags to apply to the target group"
  type        = map(string)
  default     = {}
}

# Listener Variables
variable "default_action_type" {
  description = "The type of default action for the listener (e.g., forward)"
  type        = string
  default     = "forward"
}

# Launch Template Variables
variable "launch_template_name" {
  description = "The name of the launch template"
  type        = string
}

variable "image_id" {
  description = "The ID of the AMI to use for the launch template"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the launch template"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = null
}

variable "disable_api_stop" {
  description = "Whether to disable the ability to stop the instance using the EC2 API"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Whether to disable the ability to terminate the instance using the EC2 API"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "Whether to enable EBS optimization for the instance"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "The name or ARN of the IAM instance profile to associate with the instance"
  type        = string
  default     = null
}

variable "monitoring_enabled" {
  description = "Whether to enable detailed monitoring for the instance"
  type        = bool
  default     = false
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the root volume"
  type = list(object({
    device_name  = string
    no_device    = bool
    virtual_name = string

    ebs = object({
      delete_on_termination = bool
      encrypted             = bool
      iops                  = number
      kms_key_id            = string
      snapshot_id           = string
      volume_size           = number
      volume_type           = string
    })
  }))
  default = []
}

variable "network_interfaces" {
  description = "List of network interfaces to attach to the instance"
  type = list(object({
    associate_public_ip_address = bool
    delete_on_termination       = bool
    description                 = string
    device_index                = number
    network_interface_id        = string
    private_ip_address          = string
  }))
  default = []
}


# Autoscaling Group Variables
variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "asg_subnets" {
  description = "List of subnet IDs to attach to the Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "health_check_type" {
  description = "The service to use for the health checks (e.g., EC2, ELB)"
  type        = string
  default     = "ELB"
}

variable "health_check_grace_period" {
  description = "The amount of time, in seconds, that Amazon EC2 Auto Scaling waits before checking the health status of an EC2 instance that has come into service"
  type        = number
  default     = 300
}

variable "termination_policies" {
  description = "A list of termination policies used to select the instance to terminate"
  type        = list(string)
  default     = ["Default"]
}

variable "asg_tags" {
  type = map(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
  default = {}
}

# Auto Scaling Policy Variables
variable "project" {
  description = "The project name prefix for the scaling policies"
  type        = string
}

variable "scale_up_adjustment" {
  description = "The number of instances by which to scale, when a scaling activity occurs"
  type        = number
  default     = 1
}

variable "scale_down_adjustment" {
  description = "The number of instances by which to scale, when a scaling activity occurs"
  type        = number
  default     = -1
}

variable "adjustment_type" {
  description = "The type of adjustment. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity"
  type        = string
  default     = "ChangeInCapacity"
}

variable "cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "predefined_metric_type" {
  description = "The metric type to use for the target tracking scaling policy"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "target_value" {
  description = "The target value for the metric"
  type        = number
  default     = 70
}
