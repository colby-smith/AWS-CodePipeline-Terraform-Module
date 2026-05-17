# 🧪 Smoke Test Examples

This directory contains runnable smoke-test examples for the Terraform CodePipeline module.

These examples are not full integration tests. They are intended to check that the module can be initialised, validated, and planned with common usage patterns.

## 📁 Directory Structure

```text
examples/
  basic-codeconnections/
    main.tf

  caller-supplied-codebuild-policy/
    main.tf

  multi-account-branch-mapping/
    main.tf
    variables.tf
    dv.tfvars
    st.tfvars
    pr.tfvars
```

## ✅ Prerequisites

For local smoke testing, you need:

- Terraform installed
- AWS CLI installed
- AWS credentials or AWS SSO profiles configured, depending on your local provider setup

For real AWS deployment testing, you also need:

- An existing S3 artifact bucket
- An existing AWS CodeConnections connection if using GitHub

The examples use placeholder values that are syntactically valid for smoke testing. You do not need to replace them just to check that the module initialises, validates, and plans.

Replace the placeholder values only when you want to test against real AWS resources or run `terraform apply`.

## 🧹 Formatting

Run this from the module root before running the smoke tests:

```bash
terraform fmt -recursive
```

This formats the module and all example Terraform files consistently.

## 🚀 Example 1: Basic CodeConnections

This example checks the basic GitHub/CodeConnections pipeline setup.

Run from the module root:

```bash
terraform -chdir=examples/basic-codeconnections init
terraform -chdir=examples/basic-codeconnections validate
terraform -chdir=examples/basic-codeconnections plan
```

## 🔐 Example 2: Caller-Supplied CodeBuild Policy

This example checks that a consuming project can pass additional CodeBuild IAM permissions into the module.

Run from the module root:

```bash
terraform -chdir=examples/caller-supplied-codebuild-policy init
terraform -chdir=examples/caller-supplied-codebuild-policy validate
terraform -chdir=examples/caller-supplied-codebuild-policy plan
```

## 🌍 Example 3: Multi-Account Branch Mapping

This example demonstrates the intended multi-account pattern:

```text
development branch -> dv account
staging branch     -> st account
production branch  -> pr account
```

Run the plans with the provided environment-specific variable files.

Run from the module root:

```bash
terraform -chdir=examples/multi-account-branch-mapping init
terraform -chdir=examples/multi-account-branch-mapping validate

terraform -chdir=examples/multi-account-branch-mapping plan -var-file=dv.tfvars
terraform -chdir=examples/multi-account-branch-mapping plan -var-file=st.tfvars
terraform -chdir=examples/multi-account-branch-mapping plan -var-file=pr.tfvars
```

## 🔑 Running with AWS SSO Profiles

When testing against real AWS accounts, use the correct SSO profile for each environment.

```bash
aws sso login --profile dev
AWS_PROFILE=dev terraform -chdir=examples/multi-account-branch-mapping plan -var-file=dv.tfvars
```

```bash
aws sso login --profile stage
AWS_PROFILE=stage terraform -chdir=examples/multi-account-branch-mapping plan -var-file=st.tfvars
```

```bash
aws sso login --profile production
AWS_PROFILE=production terraform -chdir=examples/multi-account-branch-mapping plan -var-file=pr.tfvars
```

## 🧩 Placeholder Values

These examples include placeholder values such as:

```text
my-org/my-repo
example-codepipeline-artifacts
arn:aws:codeconnections:eu-west-1:123456789012:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

These placeholder values are intended for smoke testing. They allow the examples to show the expected input format without requiring real project values.

You can keep the placeholders when running basic module checks such as:

```bash
terraform init
terraform validate
terraform plan
```

Replace the placeholders only when you want to test against real AWS resources or apply the module.

The examples do not create the artifact bucket or the CodeConnections connection. Those should already exist before applying the module in a real environment.

## ✅ What These Smoke Tests Cover

These examples cover:

- Basic GitHub source integration through AWS CodeConnections
- Configurable source branches
- Caller-supplied CodeBuild IAM policies
- Dev/stage/production branch-to-account mapping
- Basic module input compatibility

## ⚠️ What These Smoke Tests Do Not Cover

These examples do not fully test:

- Real GitHub webhook events
- Actual CodePipeline execution
- Actual CodeBuild runtime behaviour
- Real deployment commands inside `buildspec.yml`
- Production-grade IAM review

For deeper validation, replace the placeholder values with real values and run the pipeline in a real AWS environment.