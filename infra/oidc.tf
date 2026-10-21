# GitHub Actions OIDC identity provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name = "${local.name_prefix}-github-oidc"
  }
}

# Trust policy: only workflows from our main branch
# can assume these GitHub Actions roles
data "aws_iam_policy_document" "github_assume_role" {
  statement {
    sid    = "AllowGitHubMainBranch"
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:01ENGINEER/gatus-monitoring:ref:refs/heads/main"
      ]
    }
  }
}

# Role for the GitHub Actions Docker workflow
resource "aws_iam_role" "github_ecr" {
  name = "${local.name_prefix}-github-ecr-role"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    Name = "${local.name_prefix}-github-ecr-role"
  }
}

# ECR permissions for pushing Docker images
data "aws_iam_policy_document" "github_ecr" {
  statement {
    sid = "GetECRAuthorizationToken"

    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid = "PushImagesToGatusRepository"

    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      aws_ecr_repository.gatus.arn
    ]
  }
}

resource "aws_iam_role_policy" "github_ecr" {
  name = "${local.name_prefix}-github-ecr-policy"

  role   = aws_iam_role.github_ecr.id
  policy = data.aws_iam_policy_document.github_ecr.json
}

# Separate role for Terraform infrastructure deployment
resource "aws_iam_role" "github_terraform" {
  name = "${local.name_prefix}-github-terraform-role"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    Name = "${local.name_prefix}-github-terraform-role"
  }
}

# Terraform deployment permissions will be added after
# we review the exact AWS resources and deployment process.
#
# Do not attach AdministratorAccess automatically.
