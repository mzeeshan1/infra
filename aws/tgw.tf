data "aws_subnet" "hub_public" {
  for_each = toset(module.vpc.public_subnets["hub"])
  id       = each.value
}

data "aws_subnet" "eks_public" {
  for_each = toset(module.eks.eks_cluster_public_subnets["eu-central-1"])
  id       = each.value
}

# data "aws_subnet" "spoke_public" {
#   for_each = toset(module.vpc.public_subnets["spoke"])
#   id       = each.value
# }


locals {
  hub_subnets_by_az = {
    for s in data.aws_subnet.hub_public : s.availability_zone => s.id...
  }
  hub_tgw_subnets = [for az, ids in local.hub_subnets_by_az : ids[0]]

  eks_subnets_by_az = {
    for s in data.aws_subnet.eks_public : s.availability_zone => s.id...
  }
  eks_tgw_subnets = [for az, ids in local.eks_subnets_by_az : ids[0]]

  spoke_subnets_by_az = {
    for s in data.aws_subnet.spoke_public : s.availability_zone => s.id...
  }
  spoke_tgw_subnets = [for az, ids in local.spoke_subnets_by_az : ids[0]]

  vpc = {
    hub = {
      vpc_id  = module.vpc.vpc_id["hub"]
      subnets = local.hub_tgw_subnets
      cidr    = module.vpc.vpc_cidr_block["hub"]
    }
    eu-central-1 = {
      vpc_id  = module.eks.eks_cluster_vpc_id["eu-central-1"]
      subnets = local.eks_tgw_subnets
      cidr    = module.eks.eks_cluster_vpc_cidr_block["eu-central-1"]
    }
    # spoke = {
    #   vpc_id  = module.vpc.vpc_id["spoke"]
    #   subnets = local.spoke_tgw_subnets
    #   cidr    = module.vpc.vpc_cidr_block["spoke"]
    # }

  }
}

module "tgw" {
  source = "/Users/muhammadzeeshan/Work/MyWork/infra-modules/aws/tgw"
  tgw = {
    eu_central_1 = {
      enable_auto_accept_shared_attachments = false
      vpc_attachments = {
        for name, vpc in local.vpc : name => {
          vpc_id                                          = vpc.vpc_id
          subnet_ids                                      = vpc.subnets
          transit_gateway_default_route_table_association = false
          transit_gateway_default_route_table_propagation = false
          tgw_routes                                      = []
        }
      }
    }
  }
}

# Route in hub VPC public route table → to EKS VPC via TGW
resource "aws_route" "hub_to_eks" {
  route_table_id         = module.vpc.public_route_table_ids["hub"][0]
  destination_cidr_block = module.eks.eks_cluster_vpc_cidr_block["eu-central-1"]
  transit_gateway_id     = module.tgw.tgw_id["eu_central_1"]
}
# resource "aws_route" "hub_to_spoke" {
#   route_table_id         = module.vpc.public_route_table_ids["hub"][0]
#   destination_cidr_block = module.vpc.vpc_cidr_block["spoke"]
#   transit_gateway_id     = module.tgw.tgw_id["eu_central_1"]
# }


# Route in EKS VPC public route table → to hub VPC via TGW
resource "aws_route" "eks_to_hub" {
  for_each               = toset(module.eks.eks_cluster_public_route_table_ids["eu-central-1"])
  route_table_id         = each.value
  destination_cidr_block = module.vpc.vpc_cidr_block["hub"]
  transit_gateway_id     = module.tgw.tgw_id["eu_central_1"]
}

# Route in EKS VPC public route table → to hub VPC via TGW
# resource "aws_route" "spoke_to_hub" {
#   route_table_id         = module.vpc.public_route_table_ids["spoke"][0]
#   destination_cidr_block = module.vpc.vpc_cidr_block["hub"]
#   transit_gateway_id     = module.tgw.tgw_id["eu_central_1"]
# }
