module "ecr" {
  source = "/Users/muhammadzeeshan/Work/MyWork/infra-modules/aws/ecr"

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
