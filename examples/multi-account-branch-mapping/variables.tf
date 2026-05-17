variable "aws_region" {
  description = "AWS region to deploy the pipeline into."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name, for example dv, st, or pr."
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "pipeline_name" {
  description = "Optional explicit pipeline name."
  type        = string
  default     = null
}

variable "artifact_bucket" {
  description = "S3 bucket used by CodePipeline for artifacts."
  type        = string
}

variable "source_repository" {
  description = "GitHub repository in owner/repo format."
  type        = string
}

variable "source_branch" {
  description = "Git branch watched by this account's pipeline."
  type        = string
}

variable "connection_arn" {
  description = "AWS CodeConnections connection ARN for the GitHub repository."
  type        = string
}

variable "buildspec" {
  description = "Path to the buildspec file in the repository."
  type        = string
  default     = "buildspec.yml"
}