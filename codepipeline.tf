
#Create codepipeline for s3 website  deployment
resource "aws_codepipeline" "codepipeline" {
  name     = var.codepipeline_name 
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = var.artifact_store_type
  }

  stage {
    name = "Source"

    action {
      name             = var.source_stage 
      category         = var.source_stage 
      owner            =  var.owner 
      provider         = var.source_provider  
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestarconnections.arn
        FullRepositoryId = var.repository_id 
        BranchName       = var.branch_name 
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = var.deploy_stage
      category        = var.deploy_stage
      owner           = var.owner
      provider        = var.deploy_provider 
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.bucket.id
        Extract    = true
      }
    }
  }
}

resource "aws_codestarconnections_connection" "codestarconnections" {
  name          = var.codestar_connection_name 
  provider_type = var.codestart_connection_provider_type 
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = var.codepipeline_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.pipeline_bucket.arn,
      "${aws_s3_bucket.pipeline_bucket.arn}/*",
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"

    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.codestarconnections.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = var.codepipeline_role_policy
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}



