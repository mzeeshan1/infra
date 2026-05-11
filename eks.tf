module "eks" {
  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
  source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/eks?ref=aws-eks-v1.7.0"

  clusters = {
    eu-central-1 = {
      vpc = {
        cidr           = "10.10.0.0/16"
        azs            = local.azs
        public_subnets = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
      }
      endpoint_public_access = true
      node_groups = {
        addons = {
          capacity_type = "SPOT"
          min_size      = 2
          max_size      = 5
          desired_size  = 4
          instance_types = [
            "t3.micro",
          ]
          labels = { group = "addons" }
        }
        workers = {
          capacity_type = "SPOT"
          min_size      = 2
          max_size      = 5
          desired_size  = 4
          instance_types = [
            "t3.micro",
          ]
          labels = { group = "workers" }
        }
      }
      pod_identity_associations = {
        ack_rds_controller = {
          enabled = false
        }
      }
    }
  }
}
