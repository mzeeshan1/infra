terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket       = "tf.infra.state"
    key          = "state"
    use_lockfile = "true"
    region       = "eu-central-1"
    profile      = "terraform"
    assume_role = {
      role_arn     = "arn:aws:iam::841602633529:role/Terraform"
      session_name = "terraform"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "terraform"

  assume_role {
    role_arn     = "arn:aws:iam::841602633529:role/Terraform"
    session_name = "terraform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}
