module "oidc" {
  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
  source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/oidc?ref=aws-oidc-v1.5.0"

  github_actions_subrem_policy_statements = [
    {
      Effect = "Allow"

      Action = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
      Resource = values(module.ecr.repository_arns)
    }
  ]
  terraform_role_arn = "arn:aws:iam::261175718795:role/Terraform"
}
