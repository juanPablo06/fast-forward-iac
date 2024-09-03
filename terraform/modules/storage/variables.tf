# S3 Bucket Variables
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  validation {
    condition     = length(var.bucket_name) > 0
    error_message = "The bucket_name must not be empty."
  }
}

variable "bucket_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}

# S3 Bucket Policy Variables
variable "bucket_policy" {
  description = "The policy document for the S3 bucket"
  type        = string
  validation {
    condition     = length(var.bucket_policy) > 0
    error_message = "The bucket_policy must not be empty."
  }
}

# Ownership Controls Variables
variable "object_ownership" {
  description = "The object ownership rule for the bucket (e.g., BucketOwnerEnforced)"
  type        = string
  default     = "BucketOwnerPreferred"
  validation {
    condition     = contains(["BucketOwnerPreferred", "BucketOwnerEnforced", "ObjectWriter"], var.object_ownership)
    error_message = "The object_ownership must be one of 'BucketOwnerPreferred', 'BucketOwnerEnforced', or 'ObjectWriter'."
  }
}

# Public Access Block Variables
variable "block_public_acls" {
  description = "Whether to block public ACLs for the bucket"
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether to block public bucket policies for the bucket"
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs for the bucket"
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public bucket policies for the bucket"
  type        = bool
  default     = false
}

# Bucket ACL Variables
variable "acl" {
  description = "The canned ACL to apply to the bucket (e.g., private, public-read)"
  type        = string
  default     = "public-read"
  validation {
    condition     = contains(["private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control", "log-delivery-write"], var.acl)
    error_message = "The acl must be one of 'private', 'public-read', 'public-read-write', 'authenticated-read', 'aws-exec-read', 'bucket-owner-read', 'bucket-owner-full-control', or 'log-delivery-write'."
  }
}

# Lifecycle Configuration Variables
variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket"
  type = list(object({
    id     = string
    status = string

    filter = list(object({
      prefix = string
    }))

    noncurrent_version_expiration = list(object({
      days = number
    }))

    noncurrent_version_transition = list(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
}

# Versioning Variables
variable "versioning_status" {
  description = "The versioning status of the bucket (e.g., Enabled, Suspended)"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "The versioning_status must be either 'Enabled' or 'Suspended'."
  }
}
