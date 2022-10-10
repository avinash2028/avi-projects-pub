data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "iam_assume_role" {
            name = "iamrole"

            assume_role_policy = <<EOF
                {
                "Version": "2012-10-17",
                "Statement": [
                    {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "codebuild.amazonaws.com",
                        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/iamrole"
                    },
                    "Action": "sts:AssumeRole"
                    }
                ]
                }
                EOF
}

resource "aws_iam_role_policy" "policy" {
  role = aws_iam_role.iam_assume_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "eks:*"
      ]
    },
    {
        "Sid": "STSASSUME",
        "Effect": "Allow",
        "Action": "sts:*",
        "Resource": "*"
    }
  ]
}
POLICY
}  

resource "aws_codebuild_project" "code-build" {
  name           = "${var.project}-codebuild"
  description    = "code build for poc project"
  build_timeout  = "20"
  queued_timeout = "20"

  service_role = aws_iam_role.iam_assume_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"
    environment_variable {
      name = "AWS_ACCOUNT_ID" 
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION" 
      value = data.aws_region.current.name
    }
    environment_variable {
      name = "IMAGE_REPO_NAME"
      value = var.repo_name
    }
    environment_variable {
      name = "EKS_CLUSTER_NAME" 
      value = var.eks_cluster_name
    }
    environment_variable {
      name = "EKS_ROLE_ARN"    
      value = aws_iam_role.iam_assume_role.arn
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/avinash2028/terraform-eks-ci_cd.git"
    git_clone_depth = 1
  }

  tags = {
    Environment = "${var.project}"
  }
}