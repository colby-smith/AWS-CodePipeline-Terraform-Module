output "pipeline_name" {
  description = "Name of the created CodePipeline."
  value       = aws_codepipeline.this.name
}

output "pipeline_arn" {
  description = "ARN of the created CodePipeline."
  value       = aws_codepipeline.this.arn
}

output "pipeline_role_name" {
  description = "Name of the CodePipeline IAM role."
  value       = aws_iam_role.pipeline.name
}

output "pipeline_role_arn" {
  description = "ARN of the CodePipeline IAM role."
  value       = aws_iam_role.pipeline.arn
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project."
  value       = aws_codebuild_project.build.name
}

output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project."
  value       = aws_codebuild_project.build.arn
}

output "codebuild_role_name" {
  description = "Name of the CodeBuild IAM role."
  value       = aws_iam_role.codebuild.name
}

output "codebuild_role_arn" {
  description = "ARN of the CodeBuild IAM role."
  value       = aws_iam_role.codebuild.arn
}

output "codebuild_log_group_name" {
  description = "Name of the CodeBuild CloudWatch log group."
  value       = aws_cloudwatch_log_group.codebuild.name
}

output "codebuild_log_group_arn" {
  description = "ARN of the CodeBuild CloudWatch log group."
  value       = aws_cloudwatch_log_group.codebuild.arn
}