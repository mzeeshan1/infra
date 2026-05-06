# module "eks" {
#   source = "/Users/muhammadzeeshan/Work/MyWork/infra-modules/aws/eks"

# clusters = {
#   eu-central-1 = {
#     vpc = {
#       cidr           = "10.10.0.0/16"
#       azs            = local.azs
#       public_subnets = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
#     }
#     node_groups = {
#       addons = {
#         capacity_type = "SPOT"
#         min_size      = 0
#         max_size      = 1
#         desired_size  = 1
#         instance_types = [
#           "t3a.large",
#         ]
#         labels = { group = "addons" }
#       }
#       workers = {
#         min_size     = 0
#         max_size     = 1
#         desired_size = 1
#         instance_types = [
#           "t3a.large",
#         ]
#         labels = { group = "workers" }
#       }
#     }
#     pod_identity_associations = {
#       ack_rds_controller = {
#         enabled = false
#       }
#     }
#     cluster_enabled_log_types = [
#       "api",
#       "audit",
#       "authenticator",
#       "controllerManager",
#       "scheduler"
#     ]
#   }
# }
# }
