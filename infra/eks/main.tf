terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# -------------------------------
# VPC (Public Subnets Only)
# -------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-south-1a", "ap-south-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false

  # ✅ CORRECT FLAG (THIS IS THE KEY)
  map_public_ip_on_launch = true
}

# -------------------------------
# EKS Cluster + Spot Node Group
# -------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = "mern-eks"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]

  enable_irsa = true

  eks_managed_node_groups = {
    spot_nodes = {
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }
  }
}
