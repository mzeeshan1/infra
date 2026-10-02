module "oidc" {
  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
  source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/oidc?ref=aws-oidc-v1.4.0"


  github_oidc_subjects = [
    "mzeeshan1/subscription-reminder:ref:refs/heads/main",
    "mzeeshan1/subscription-reminder:ref:refs/tags/*",
    "mzeeshan1/infra:ref:refs/heads/main",
    "mzeeshan1/infra:pull_request"
  ]
  github_actions_policy_statements = [
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
}
