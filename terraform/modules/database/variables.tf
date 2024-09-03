# RDS Security Group Variables
variable "db_sg_name" {
  description = "The name of the security group for the RDS instance"
  type        = string
  validation {
    condition     = length(var.db_sg_name) > 0
    error_message = "The db_sg_name must not be empty."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC in which to create the security group"
  type        = string
}

variable "security_group_ingress" {
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

variable "security_group_egress" {
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

# RDS Subnet Group Variables
variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
  validation {
    condition     = length(var.db_subnet_group_name) > 0
    error_message = "The db_subnet_group_name must not be empty."
  }
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs to associate with the DB subnet group"
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet ID must be specified."
  }
}

variable "db_subnet_group_tags" {
  description = "Tags to apply to the DB subnet group"
  type        = map(string)
  default     = {}
}

# RDS Instance Variables
variable "db_instance_name" {
  description = "The identifier for the RDS instance"
  type        = string
  validation {
    condition     = length(var.db_instance_name) > 0
    error_message = "The db_instance_name must not be empty."
  }
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes (GiB) for the RDS instance"
  type        = number
  default     = 10
}

variable "allow_major_version_upgrade" {
  description = "Whether to allow major version upgrades for the RDS instance"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Whether to enable automatic minor version upgrades for the RDS instance"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The storage type for the RDS instance (e.g., gp2, io1)"
  type        = string
  default     = "gp2"
}

variable "engine" {
  description = "The database engine to use for the RDS instance (e.g., mysql, postgresql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The version number of the database engine to use"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "The instance class for the RDS instance (e.g., db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create when the RDS instance is created"
  type        = string
}

variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
  default     = ""
}

variable "manage_master_user_password" {
  description = "Whether to manage the master user password with Secrets Manager"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the instance is deleted"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The name of the final DB snapshot when skip_final_snapshot is false"
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Whether to deploy the RDS instance in a Multi-AZ configuration"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the RDS instance"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in UTC"
  type        = string
  default     = "Mon:05:00-Mon:06:00"
}

variable "blue_green_update_enabled" {
  description = "Whether to enable Blue/Green deployments for database updates"
  type        = bool
  default     = true
}

variable "db_tags" {
  description = "Tags to apply to the RDS instance"
  type        = map(string)
  default     = {}
}
