variable "region" {
  description = "Alibaba Cloud region"
  type        = string
  default     = "cn-shanghai"
}

variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of: dev, staging, prod"
  }
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "hello-world"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "platform-team"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "vswitch_id" {
  description = "VSwitch ID for SAE and RDS"
  type        = string
}

variable "image_url" {
  description = "Container image URL for SAE deployment"
  type        = string
}

variable "db_password" {
  description = "RDS master account password"
  type        = string
  sensitive   = true
}

variable "sae_cpu" {
  description = "SAE CPU in mCPU"
  type        = number
  default     = 500
}

variable "sae_memory" {
  description = "SAE memory in MB"
  type        = number
  default     = 1024
}

variable "sae_replicas" {
  description = "SAE replica count"
  type        = number
  default     = 1
}

variable "rds_instance_type" {
  description = "RDS instance class"
  type        = string
  default     = "pg.n2.2c.1m"
}

variable "rds_storage_size" {
  description = "RDS storage in GB"
  type        = number
  default     = 20
}
