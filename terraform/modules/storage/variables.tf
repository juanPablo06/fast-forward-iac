# S3 Bucket Variables
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}

# Ownership Controls Variables
variable "object_ownership" {
  description = "The object ownership rule for the bucket (e.g., BucketOwnerEnforced)"
  type        = string
  default     = "BucketOwnerPreferred"
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

    expiration = list(object({
      days = number
    }))

    transition = list(object({
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
}
