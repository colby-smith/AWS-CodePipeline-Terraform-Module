aws_region = "eu-west-1"

environment = "pr"

project_name    = "personal-site-pr"
pipeline_name   = "personal-site-pr-pipeline"
artifact_bucket = "personal-site-pr-codepipeline-artifacts"

source_repository = "colbysmith99/personal-site"
source_branch     = "production"

connection_arn = "arn:aws:codeconnections:eu-west-1:333333333333:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

buildspec = "infra/terraform/buildspec.yml"