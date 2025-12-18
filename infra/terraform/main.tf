############################
# Terraform Setup
############################
terraform {
  required_version = ">=1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

############################
# VPC (Cheap, minimal)
############################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = false   # Save cost
  single_nat_gateway = false

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

############################
# EKS Cluster
############################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  enable_irsa = true

  ############################
  # Cheapest possible Spot Node Group
  ############################
  eks_managed_node_groups = {
    spot_nodes = {
      min_size     = 2
      desired_size = 2
      max_size     = 2

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"

      labels = {
        lifecycle = "spot"
      }

      tags = {
        Name = "${var.cluster_name}-spot-node"
      }
    }
  }

  tags = {
    Environment = "dev"
    Owner       = "you"
  }
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig_${var.cluster_name}"

  content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name                     = module.eks.cluster_name
    cluster_endpoint                 = module.eks.cluster_endpoint
    cluster_ca                       = module.eks.cluster_certificate_authority_data
  })
}
