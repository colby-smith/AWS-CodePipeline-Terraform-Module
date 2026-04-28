variable "project_name" {
  description = "Logical name for this pipeline/project."
  type        = string
}

variable "pipeline_name" {
  description = "Optional override for the CodePipeline name. Defaults to <project_name>-pipeline."
  type        = string
  default     = null
}

variable "artifact_bucket" {
  description = "Name of the S3 bucket used for CodePipeline artifacts. Must already exist."
  type        = string
}

variable "source_repository" {
  description = "Repository identifier (e.g. owner/repo for GitHub, or CodeCommit repo name)."
  type        = string
}

variable "source_branch" {
  description = "Branch to build from."
  type        = string
  default     = "main"
}

variable "source_provider" {
  description = "Source provider for the pipeline (e.g. GitHub, CodeCommit, CodeStarSourceConnection)."
  type        = string
  default     = "CodeStarSourceConnection"
}

variable "connection_arn" {
  description = "ARN of the CodeStar Connections connection (required when using CodeStarSourceConnection)."
  type        = string
  default     = null
}

variable "buildspec" {
  description = "Path to the buildspec file in the repository."
  type        = string
  default     = "buildspec.yml"
}

variable "codebuild_image" {
  description = "Docker image for the CodeBuild environment."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

variable "codebuild_compute_type" {
  description = "Compute type for CodeBuild."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_timeout_minutes" {
  description = "Timeout for CodeBuild in minutes."
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Additional environment variables for the CodeBuild project."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "PLAINTEXT")
  }))
  default = []
}
