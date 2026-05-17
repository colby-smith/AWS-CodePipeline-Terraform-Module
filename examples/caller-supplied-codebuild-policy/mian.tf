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

data "aws_iam_policy_document" "project_specific_codebuild_permissions" {
  statement {
    sid = "WriteDeploymentObjects"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::example-deployment-bucket/*"
    ]
  }

  statement {
    sid = "ListDeploymentBucket"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::example-deployment-bucket"
    ]
  }
}

module "pipeline" {
  source = "../../"

  project_name      = "example-caller-supplied-codebuild-policy"
  artifact_bucket   = "example-codepipeline-artifacts"
  source_repository = "my-org/my-repo"
  source_branch     = "main"

  source_provider = "CodeStarSourceConnection"
  connection_arn  = "arn:aws:codeconnections:eu-west-1:123456789012:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  buildspec = "buildspec.yml"

  additional_codebuild_policy_documents = [
    data.aws_iam_policy_document.project_specific_codebuild_permissions.json
  ]

  environment_variables = [
    {
      name  = "ENV"
      value = "example"
      type  = "PLAINTEXT"
    },
    {
      name  = "DEPLOYMENT_BUCKET"
      value = "example-deployment-bucket"
      type  = "PLAINTEXT"
    }
  ]

  tags = {
    Project   = "example-caller-supplied-codebuild-policy"
    ManagedBy = "terraform"
  }
}