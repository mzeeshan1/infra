module "eks" {
  #checkov:skip=CKV_TF_1: Using semantic version tags intentionally
  source = "git::https://github.com/mzeeshan1/infra-modules.git//aws/eks?ref=aws-eks-v1.12.3"

  clusters = {
    eu-central-1 = {
      vpc = {
        cidr           = "10.10.0.0/16"
        azs            = local.azs
        public_subnets = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
        public_subnet_tags_per_az = {
          eu-central-1a = {
            "kubernetes.io/cluster/eu-central-1" = "shared"
            "kubernetes.io/role/elb"             = "1"
          }
          eu-central-1b = {
            "kubernetes.io/cluster/eu-central-1" = "shared"
            "kubernetes.io/role/elb"             = "1"
          }
          eu-central-1c = {
            "kubernetes.io/cluster/eu-central-1" = "shared"
            "kubernetes.io/role/elb"             = "1"
          }
        }
      }
      endpoint_public_access = true
      node_groups = {
        addons = {
          capacity_type = "SPOT"
          min_size      = 0
          max_size      = 5
          desired_size  = 3
          instance_types = [
            "m7i-flex.large",
          ]
          labels = { group = "addons" }
        }
        workers = {
          capacity_type = "SPOT"
          min_size      = 0
          max_size      = 5
          desired_size  = 3
          instance_types = [
            "m7i-flex.large",
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
