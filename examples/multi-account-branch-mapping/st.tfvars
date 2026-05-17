aws_region = "eu-west-1"

environment = "st"

project_name    = "personal-site-st"
pipeline_name   = "personal-site-st-pipeline"
artifact_bucket = "personal-site-st-codepipeline-artifacts"

source_repository = "colbysmith99/personal-site"
source_branch     = "staging"

connection_arn = "arn:aws:codeconnections:eu-west-1:222222222222:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

buildspec = "infra/terraform/buildspec.yml"