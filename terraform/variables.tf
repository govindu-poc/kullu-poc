variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, stage, prod)"
  type        = string
}

variable "cluster_name" {
  description = "Base name for the EKS cluster"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "ami_type" {
  description = "AMI type for EKS nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "instance_types" {
  description = "List of EC2 instance types for node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired node count"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum node count"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
  default     = 5
}