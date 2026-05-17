locals {
  pipeline_name            = coalesce(var.pipeline_name, "${var.project_name}-pipeline")
  codebuild_project_name   = coalesce(var.codebuild_project_name, "${var.project_name}-build")
  codebuild_log_group_name = coalesce(var.codebuild_log_group_name, "/aws/codebuild/${local.codebuild_project_name}")

  source_configuration = var.source_provider == "CodeStarSourceConnection" ? {
    ConnectionArn    = var.connection_arn
    FullRepositoryId = var.source_repository
    BranchName       = var.source_branch
    DetectChanges    = tostring(var.detect_changes)
  } : var.source_provider == "CodeCommit" ? {
    RepositoryName       = var.source_repository
    BranchName           = var.source_branch
    PollForSourceChanges = tostring(var.codecommit_poll_for_source_changes)
  } : {}
}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "codebuild" {
  name              = local.codebuild_log_group_name
  retention_in_days = var.codebuild_log_retention_days

  tags = var.tags
}

resource "aws_iam_role" "pipeline" {
  name                 = "${var.project_name}-codepipeline-role"
  description          = "Service role used by CodePipeline for ${var.project_name}."
  assume_role_policy   = data.aws_iam_policy_document.pipeline_assume_role.json
  permissions_boundary = var.permissions_boundary_arn

  tags = var.tags
}

data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "pipeline" {
  name   = "${var.project_name}-codepipeline-policy"
  role   = aws_iam_role.pipeline.id
  policy = data.aws_iam_policy_document.pipeline_policy.json
}

data "aws_iam_policy_document" "pipeline_policy" {
  statement {
    sid = "ArtifactBucketAccess"

    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.artifact_bucket}"
    ]
  }

  statement {
    sid = "ArtifactObjectAccess"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.artifact_bucket}/*"
    ]
  }

  statement {
    sid = "StartCodeBuild"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      aws_codebuild_project.build.arn
    ]
  }

  statement {
    sid = "PassCodeBuildRole"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.codebuild.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.source_provider == "CodeStarSourceConnection" ? [1] : []

    content {
      sid = "UseCodeConnection"

      actions = [
        "codeconnections:UseConnection"
      ]

      resources = [
        var.connection_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = var.source_provider == "CodeCommit" ? [1] : []

    content {
      sid = "UseCodeCommitSource"

      actions = [
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:CancelUploadArchive"
      ]

      resources = [
        "arn:${data.aws_partition.current.partition}:codecommit:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.source_repository}"
      ]
    }
  }
}

data "aws_iam_policy_document" "pipeline_additional" {
  count = length(var.additional_codepipeline_policy_documents) > 0 ? 1 : 0

  source_policy_documents = var.additional_codepipeline_policy_documents
}

resource "aws_iam_role_policy" "pipeline_additional" {
  count = length(var.additional_codepipeline_policy_documents) > 0 ? 1 : 0

  name   = "${var.project_name}-codepipeline-additional-policy"
  role   = aws_iam_role.pipeline.id
  policy = data.aws_iam_policy_document.pipeline_additional[0].json
}

resource "aws_iam_role" "codebuild" {
  name                 = "${var.project_name}-codebuild-role"
  description          = "Service role used by CodeBuild for ${var.project_name}."
  assume_role_policy   = data.aws_iam_policy_document.codebuild_assume_role.json
  permissions_boundary = var.permissions_boundary_arn

  tags = var.tags
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "${var.project_name}-codebuild-policy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid = "CodeBuildLogsAccess"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.codebuild.arn}:*"
    ]
  }

  statement {
    sid = "ArtifactBucketRead"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.artifact_bucket}"
    ]
  }

  statement {
    sid = "ArtifactObjectReadWrite"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.artifact_bucket}/*"
    ]
  }
}

data "aws_iam_policy_document" "codebuild_additional" {
  count = length(var.additional_codebuild_policy_documents) > 0 ? 1 : 0

  source_policy_documents = var.additional_codebuild_policy_documents
}

resource "aws_iam_role_policy" "codebuild_additional" {
  count = length(var.additional_codebuild_policy_documents) > 0 ? 1 : 0

  name   = "${var.project_name}-codebuild-additional-policy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_additional[0].json
}

resource "aws_codebuild_project" "build" {
  name           = local.codebuild_project_name
  description    = "Build project for ${var.project_name}."
  service_role   = aws_iam_role.codebuild.arn
  build_timeout  = var.codebuild_timeout_minutes
  queued_timeout = var.codebuild_queued_timeout_minutes

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.codebuild_compute_type
    image           = var.codebuild_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.codebuild_privileged_mode

    dynamic "environment_variable" {
      for_each = {
        for environment_variable in var.environment_variables :
        environment_variable.name => environment_variable
      }

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild.name
      stream_name = "build"
      status      = "ENABLED"
    }
  }

  tags = var.tags
}

resource "aws_codepipeline" "this" {
  name     = local.pipeline_name
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = var.source_provider
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = local.source_configuration
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = var.build_output_artifact_enabled ? ["BuildOutput"] : []

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.source_provider != "CodeStarSourceConnection" || var.connection_arn != null
      error_message = "connection_arn must be provided when source_provider is CodeStarSourceConnection."
    }

    precondition {
      condition     = var.source_provider != "CodeStarSourceConnection" || can(regex("^[^/]+/[^/]+$", var.source_repository))
      error_message = "source_repository must be in owner/repository format when using CodeStarSourceConnection."
    }
  }
}