aws_region = "eu-west-1"

environment = "dv"

project_name    = "personal-site-dv"
pipeline_name   = "personal-site-dv-pipeline"
artifact_bucket = "personal-site-dv-codepipeline-artifacts"

source_repository = "colbysmith99/personal-site"
source_branch     = "development"

connection_arn = "arn:aws:codeconnections:eu-west-1:111111111111:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

buildspec = "infra/terraform/buildspec.yml"