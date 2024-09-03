variable "environment" {
  description = "The environment in which the resources will be created"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instances"
  type        = string
}

variable "min_size" {
  description = "The minimum number of instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of instances in the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "The desired number of instances in the ASG"
  type        = number
}
