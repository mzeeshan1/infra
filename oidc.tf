module "eks" {
  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
  source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/oidc?ref=aws-oidc-v1.0.0"

  github_oidc_subjects = [
    "mzeeshan1/subscription-reminder:ref:refs/heads/main"
  ]
}
