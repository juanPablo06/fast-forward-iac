# VPC Configuration
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
  description = "The tenancy of the VPC instances (default or dedicated)"
  type        = string
  default     = "default"
}

variable "vpc_enable_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

# Subnet Configuration
variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_tags" {
  description = "Tags to apply to the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags to apply to the private subnets"
  type        = map(string)
  default     = {}
}

# Internet Gateway Configuration
variable "internet_gateway_tags" {
  description = "Tags to apply to the internet gateway"
  type        = map(string)
  default     = {}
}

# EIP Configuration
variable "eip_domain" {
  description = "The domain for the EIPs (vpc or standard)"
  type        = string
  default     = "vpc"
}

variable "eip_tags" {
  description = "Tags to apply to the EIPs"
  type        = map(string)
  default     = {}
}

# NAT Gateway Configuration
variable "nat_gateway_tags" {
  description = "Tags to apply to the NAT gateways"
  type        = map(string)
  default     = {}
}

# Route Table Configuration
variable "public_route_cidr_block" {
  description = "The CIDR block for the public route (usually 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_route_cidr_block" {
  description = "The CIDR block for the private route (usually 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_route_table_tags" {
  description = "Tags to apply to the public route tables"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Tags to apply to the private route tables"
  type        = map(string)
  default     = {}
}
