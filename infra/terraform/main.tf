################################################################################
# EKS
################################################################################

module "vpc" {
  source = "./modules/vpc"
  env = var.env
  vpc_name = var.vpc_name
  cluster_name = var.eks_cluster_name
  cidrs = var.cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  eks_worker_subnet_cidrs = var.eks_worker_subnet_cidrs
  eks_control_plane_subnet_cidrs = var.eks_control_plane_subnet_cidrs
  azs = var.azs
}

module "eks" {
  source  = "./modules/eks"
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  env = var.env
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.eks_worker_subnet_ids
  control_plane_subnet_ids       = module.vpc.eks_control_plane_subnet_ids
  cluster_endpoint_public_access = true
  cluster_security_group_name    = "${var.eks_cluster_name}-cluster"
  node_security_group_name       = "${var.eks_cluster_name}-node"
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    iam_role_attach_cni_policy = true
    disk_size            = 100
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 100
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = false
          delete_on_termination = true
        }
      }
    }
  }
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  eks_managed_node_groups = {
    default = {
      name                 = "default"
      use_name_prefix      = false
      launch_template_name = "${var.eks_cluster_name}-default-launch-template"
      #      remote_access = {
      #        ec2_ssh_key               = ""
      #        source_security_group_ids = []
      #      }
      ebs_optimized           = true
      instance_types       = ["t3.xlarge", "t3a.xlarge"]
      disk_size            = 50
      capacity_type        = "ON_DEMAND" #ON_DEMAND,SPOT
      min_size             = 1
      max_size             = 3
      desired_size         = 1
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = false
            delete_on_termination = true
          }
        }
      }
      labels = {
        nodegroup-name = "default"
        cluster-name  = var.eks_cluster_name
      }
    }
  }
}


data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "./modules/eks/modules/iam-assumable-role-with-oidc"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole_${var.env}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}


resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.aws_eks_addon_ebs_csi
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

module "vpc_cni_irsa" {
  source  = "./modules/eks/modules/iam-role-for-service-accounts-eks"

  role_name = "AmazonEKS_CNI_Policy_${var.env}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    "Name": "AmazonEKS_CNI_Policy_${var.env}"
  }
}
