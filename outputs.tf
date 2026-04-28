output "pipeline_name" {
  description = "Name of the created CodePipeline."
  value       = aws_codepipeline.this.name
}

output "pipeline_arn" {
  description = "ARN of the created CodePipeline."
  value       = aws_codepipeline.this.arn
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project."
  value       = aws_codebuild_project.build.name
}
