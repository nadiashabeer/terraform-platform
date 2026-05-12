variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/qa/prod)"
  type        = string
}

variable "roles" {
  description = "List of IAM roles to create"
  type = list(object({
    name        = string
    description = optional(string)
    policy_type = optional(string, "custom")
    
    # For AWS managed policies
    aws_managed_policies = optional(list(string), [])
    
    # For custom inline policies
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])
    
    # For custom policy documents
    custom_policy_document = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
