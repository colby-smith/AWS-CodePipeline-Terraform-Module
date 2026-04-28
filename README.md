# Project Title

## 📘 Overview

A reusable Terraform module that provisions an AWS CodePipeline and CodeBuild setup.
It provides a clean, environment‑agnostic CI/CD pipeline that can be consumed by any project without embedding provider or backend configuration.

## 🎯 Purpose of This Repository

This repository exists to provide a lightweight, production-ready Terraform module for creating CI/CD pipelines in AWS. It is intentionally minimal so it can be reused across multiple accounts, environments, and application stacks without much modification.

## ✨ Features

- Creates an AWS CodePipeline with a configurable source stage.
- Provisions a CodeBuild project with customizable environment variables.
- Automatically generates IAM roles and policies for both services.
- Supports GitHub, CodeCommit, and CodeStar Connections.
- Allows custom buildspec paths and build environment configuration.
- Fully provider-agnostic and backend-agnostic module design.

## 🚀 Getting Started

To use this module, call it from your Terraform project:

```hcl
module "pipeline" {
  source = "github.com/ColbySmith/Terraform-AWS-CodePipeline-Module"

  project_name      = "my-app"
  artifact_bucket   = "my-artifact-bucket"
  source_repository = "my-org/my-repo"
  source_branch     = "main"

  source_provider = "CodeStarSourceConnection"
  connection_arn  = "arn:aws:codestar-connections:region:account-id:connection/xxxx"

  buildspec = "buildspec.yml"
}
```
Your project must define its own AWS provider, backend configuration, and assume-role setup (if applicable).

## 📦 Usage

This module is typically used inside a project’s `infrastructure/` directory to provision CI/CD pipelines for that specific application.

**Typical workflow:**

1. Configure your AWS provider and backend in your project repo
2. Call this module
3. Run `terraform fmt -check`
4. Run `terraform init`
5. Run `terraform validate`
6. Run `terraform plan`
7. Run `terraform apply`

The module will create:

- CodePipeline
- CodeBuild project
- IAM roles
- Artifact store configuration
- CodeStar Connections


## 🏗️ Infrastructure

This repository contains only the Terraform module. It does not deploy infrastructure by itself. All infrastructure deployment happens in the consuming project, which provides:

- Provider configuration
- Backend configuration
- Environment-specific variables
- IAM assume-role configuration

## 🧪 Testing

This module does not include automated tests. You can validate the module locally by running:

```bash
cd tests
export AWS_ACCESS_KEY_ID=dummyid
export AWS_SECRET_ACCESS_KEY=dummykey
terraform init -lock=false -backend=false
terraform validate
terraform plan
```

## 📄 License

[MIT License](./LICENSE)
