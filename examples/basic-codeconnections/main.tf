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
  region = "eu-west-1"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

module "pipeline" {
  source = "../../"

  project_name      = "example-basic-codeconnections"
  artifact_bucket   = "example-codepipeline-artifacts"
  source_repository = "my-org/my-repo"
  source_branch     = "main"

  source_provider = "CodeStarSourceConnection"
  connection_arn  = "arn:aws:codeconnections:eu-west-1:123456789012:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  buildspec = "buildspec.yml"

  environment_variables = [
    {
      name  = "ENV"
      value = "example"
      type  = "PLAINTEXT"
    }
  ]

  tags = {
    Project   = "example-basic-codeconnections"
    ManagedBy = "terraform"
  }
}