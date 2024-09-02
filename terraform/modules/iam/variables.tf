# IAM Role Variables
variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "role_description" {
  description = "The description of the IAM role"
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "The assume role policy document in JSON format"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "A list of ARNs of managed policies to attach to the role"
  type        = list(string)
  default     = []
}

# IAM Policy Variables
variable "policy_names" {
  description = "A list of names for the custom IAM policies"
  type        = list(string)
  default     = []
}

variable "policy_descriptions" {
  description = "A list of descriptions for the custom IAM policies"
  type        = list(string)
  default     = []
}

variable "policy_documents" {
  description = "A list of policy documents in JSON format for the custom IAM policies"
  type        = list(string)
  default     = []
}
