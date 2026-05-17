terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

module "pipeline" {
  source = "../../"

  project_name      = var.project_name
  pipeline_name     = var.pipeline_name
  artifact_bucket   = var.artifact_bucket
  source_repository = var.source_repository
  source_branch     = var.source_branch

  source_provider = "CodeStarSourceConnection"
  connection_arn  = var.connection_arn

  buildspec = var.buildspec

  environment_variables = [
    {
      name  = "ENV"
      value = var.environment
      type  = "PLAINTEXT"
    }
  ]

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}