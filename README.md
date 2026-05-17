# Terraform AWS CodePipeline Module

## 📘 Overview

A reusable Terraform module that provisions an AWS CodePipeline and CodeBuild setup.

It provides a clean, environment-agnostic CI/CD pipeline that can be consumed by multiple projects without embedding provider or backend configuration inside the module.

## 🎯 Purpose of This Repository

This repository provides a lightweight Terraform module for creating CI/CD pipelines in AWS.

The module creates the core pipeline resources, while the consuming project controls:

- provider and backend configuration
- environment-specific values
- AWS SSO or assume-role setup
- workload-specific deployment permissions

This keeps the module reusable across different accounts, environments, and application stacks.

## ✨ Features

- Creates an AWS CodePipeline with a configurable source stage.
- Provisions a CodeBuild project with configurable build settings.
- Supports GitHub through AWS CodeConnections using the `CodeStarSourceConnection` source action provider.
- Supports AWS CodeCommit.
- Supports configurable source branches.
- Allows custom buildspec paths.
- Supports CodeBuild environment variables.
- Automatically generates baseline IAM roles and policies for CodePipeline and CodeBuild.
- Allows caller-supplied IAM policy documents for project-specific permissions.
- Supports optional IAM permissions boundaries.
- Creates a managed CloudWatch log group for CodeBuild.
- Fully provider-agnostic and backend-agnostic module design.

## 🚀 Getting Started

To use this module, call it from your Terraform project:

```hcl
module "pipeline" {
  source = "git::https://github.com/ColbySmith/Terraform-AWS-CodePipeline-Module.git?ref=v1.0.0"

  project_name      = "my-app"
  artifact_bucket   = "my-artifact-bucket"
  source_repository = "my-org/my-repo"
  source_branch     = "main"

  source_provider = "CodeStarSourceConnection"
  connection_arn  = "arn:aws:codeconnections:eu-west-1:123456789012:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  buildspec = "buildspec.yml"
}
```

Your project must define its own AWS provider, backend configuration, and assume-role setup if applicable.

The artifact bucket must already exist before using this module.

If using GitHub, the AWS CodeConnections connection must also already exist.

## 📦 Usage

This module is typically used inside a project’s infrastructure directory to provision a CI/CD pipeline for that specific application.

**Typical workflow:**

1. Configure your AWS provider and backend in the consuming project.
2. Create or reference an existing CodePipeline artifact bucket.
3. Create or reference an existing AWS CodeConnections connection if using GitHub.
4. Call this module.
5. Run `terraform fmt -recursive`.
6. Run `terraform init`.
7. Run `terraform validate`.
8. Run `terraform plan`.
9. Run `terraform apply`.

The module will create:

- CodePipeline
- CodeBuild project
- IAM roles and policies
- CloudWatch log group for CodeBuild
- CodePipeline artifact store configuration

### Caller-supplied permissions

The module creates baseline IAM permissions for CodePipeline and CodeBuild.

Project-specific deployment permissions should be passed in by the consuming project.

Example:

```hcl
data "aws_iam_policy_document" "deployment_permissions" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::example-deployment-bucket/*"
    ]
  }
}

module "pipeline" {
  source = "git::https://github.com/ColbySmith/Terraform-AWS-CodePipeline-Module.git?ref=v1.0.0"

  project_name      = "my-app"
  artifact_bucket   = "my-artifact-bucket"
  source_repository = "my-org/my-repo"
  source_branch     = "main"

  source_provider = "CodeStarSourceConnection"
  connection_arn  = "arn:aws:codeconnections:eu-west-1:123456789012:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  buildspec = "buildspec.yml"

  additional_codebuild_policy_documents = [
    data.aws_iam_policy_document.deployment_permissions.json
  ]
}
```

This keeps the module reusable without granting broad administrator permissions.

### Multi-account branch mapping

This module can be deployed separately into multiple AWS accounts.

Example:

```text
development branch -> dev account
staging branch     -> stage account
production branch  -> production account
```

Each account calls the same module with different values:

```hcl
project_name      = "my-app-dev"
source_branch     = "development"
artifact_bucket   = "my-app-dev-codepipeline-artifacts"
connection_arn    = "arn:aws:codeconnections:eu-west-1:111111111111:connection/..."
```

## 🏗️ Infrastructure

This repository contains only the Terraform module. It does not deploy application infrastructure by itself.

All infrastructure deployment happens in the consuming project, which provides:

- provider configuration
- backend configuration
- environment-specific variables
- IAM assume-role or AWS SSO configuration
- artifact bucket
- CodeConnections connection
- application infrastructure
- deployment targets
- workload-specific IAM permissions

## 🧪 Testing

This repository includes runnable smoke-test examples under the `examples/` directory.

```text
examples/
  basic-codeconnections/
  caller-supplied-codebuild-policy/
  multi-account-branch-mapping/
```

These examples check that the module can be initialised, validated, and planned with common usage patterns.

They are not full integration tests and do not prove that a real pipeline execution will succeed.

For more details on setup notes and test commands, see [`examples/README.md`](./examples/README.md).

Basic smoke-test workflow from the module root:

```bash
terraform fmt -recursive

terraform -chdir=examples/basic-codeconnections init
terraform -chdir=examples/basic-codeconnections validate
terraform -chdir=examples/basic-codeconnections plan
```

## 📄 License

[MIT License](./LICENSE)