terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "eu-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

module "pipeline" {
  source = "../"

  project_name      = "example-project"
  artifact_bucket   = "my-artifact-bucket-name"
  source_repository = "my-org/my-repo"
  source_branch     = "main"

  # For CodeStarSourceConnection
  source_provider = "CodeStarSourceConnection"
  connection_arn  = "arn:aws:codestar-connections:eu-west-1:123456789012:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  buildspec = "buildspec.yml"

  environment_variables = [
    {
      name  = "ENV"
      value = "dev"
    }
  ]
}
