variable "project_name" {
  description = "Logical name for this pipeline/project."
  type        = string
}

variable "pipeline_name" {
  description = "Optional override for the CodePipeline name. Defaults to <project_name>-pipeline."
  type        = string
  default     = null
}

variable "codebuild_project_name" {
  description = "Optional override for the CodeBuild project name. Defaults to <project_name>-build."
  type        = string
  default     = null
}

variable "artifact_bucket" {
  description = "Name of the S3 bucket used for CodePipeline artifacts. Must already exist."
  type        = string
}

variable "source_repository" {
  description = "Repository identifier. For CodeConnections, use owner/repo. For CodeCommit, use the repository name."
  type        = string
}

variable "source_branch" {
  description = "Branch to build from."
  type        = string
  default     = "main"
}

variable "source_provider" {
  description = "Source provider for the pipeline. Supported values: CodeStarSourceConnection, CodeCommit."
  type        = string
  default     = "CodeStarSourceConnection"

  validation {
    condition = contains([
      "CodeStarSourceConnection",
      "CodeCommit"
    ], var.source_provider)

    error_message = "source_provider must be one of: CodeStarSourceConnection, CodeCommit."
  }
}

variable "connection_arn" {
  description = "ARN of the CodeConnections/CodeStar connection. Required when using CodeStarSourceConnection."
  type        = string
  default     = null
}

variable "detect_changes" {
  description = "Whether CodeConnections should automatically trigger the pipeline when the source branch changes."
  type        = bool
  default     = true
}

variable "codecommit_poll_for_source_changes" {
  description = "Whether CodeCommit should poll for source changes."
  type        = bool
  default     = false
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

variable "codebuild_queued_timeout_minutes" {
  description = "Queued timeout for CodeBuild in minutes."
  type        = number
  default     = 30
}

variable "codebuild_privileged_mode" {
  description = "Whether to enable privileged mode for CodeBuild."
  type        = bool
  default     = false
}

variable "codebuild_log_group_name" {
  description = "Optional CloudWatch log group name for CodeBuild."
  type        = string
  default     = null
}

variable "codebuild_log_retention_days" {
  description = "CloudWatch log retention in days for CodeBuild logs."
  type        = number
  default     = 30
}

variable "build_output_artifact_enabled" {
  description = "Whether the Build action should produce a BuildOutput artifact."
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "Additional environment variables for the CodeBuild project."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "PLAINTEXT")
  }))
  default = []

  validation {
    condition = alltrue([
      for environment_variable in var.environment_variables :
      contains(["PLAINTEXT", "PARAMETER_STORE", "SECRETS_MANAGER"], environment_variable.type)
    ])

    error_message = "Environment variable type must be one of: PLAINTEXT, PARAMETER_STORE, SECRETS_MANAGER."
  }
}

variable "additional_codebuild_policy_documents" {
  description = "Additional IAM policy documents, as JSON strings, to attach to the CodeBuild role."
  type        = list(string)
  default     = []
}

variable "additional_codepipeline_policy_documents" {
  description = "Additional IAM policy documents, as JSON strings, to attach to the CodePipeline role."
  type        = list(string)
  default     = []
}

variable "permissions_boundary_arn" {
  description = "Optional permissions boundary ARN applied to CodePipeline and CodeBuild roles."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to supported resources."
  type        = map(string)
  default     = {}
}