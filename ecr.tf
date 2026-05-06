module "ecr" {
  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
  source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/ecr?ref=aws-ecr-v1.2.0"
  repositories = {
    subscription-reminder = {
      name         = "subscription-reminder"
      scan_on_push = true
      image_tag_mutability_exclusion_filters = [{
        filter      = "v*"
        filter_type = "WILDCARD"
      }]
    }
    subman = {
      name         = "subman"
      scan_on_push = true
      image_tag_mutability_exclusion_filters = [{
        filter      = "v*"
        filter_type = "WILDCARD"
      }]
    }
  }
}
