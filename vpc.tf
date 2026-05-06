# module "vpc" {
#  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
#   source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/vpc?ref=aws-vpc-v1.0.0"
#   vpc = {
#     hub = {
#       cidr                       = "10.100.0.0/16"
#       azs                        = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
#       public_subnets             = ["10.100.0.0/19", "10.100.32.0/19", "10.100.64.0/19"]
#       manage_default_network_acl = false
#     }
#   }
# }
