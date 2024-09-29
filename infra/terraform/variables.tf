variable "env" {
  type        = string
  description = "environment"
  default     = "demo"
}

################################################################################
# VPC
################################################################################

variable "cidrs" {
  type        = string
  description = "CIDR values"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "Demo VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.69.0/24", "10.0.70.0/24", "10.0.71.0/24"]
}

variable "eks_worker_subnet_cidrs" {
  type        = list(string)
  description = "EKS Worker Subnet CIDR values"
  default     = ["10.0.72.0/22", "10.0.76.0/22", "10.0.80.0/22"]
}

variable "eks_control_plane_subnet_cidrs" {
  type        = list(string)
  description = "EKS Control Plane Subnet CIDR values"
  default     = ["10.0.85.0/24", "10.0.86.0/24", "10.0.87.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks."
  default     = ["0.0.0.0/0"]
}

variable "ipv6_cidr_blocks" {
  type        = list(string)
  description = "List of IPv6 CIDR blocks."
  default     = ["::/0"]
}

################################################################################
# EKS
################################################################################

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "demo-eks"
}

variable "eks_cluster_version" {
  type        = string
  description = "EKS Cluster Version"
  default     = "1.30"
}

variable "aws_eks_addon_ebs_csi" {
  type = string
  description = "EKS addon EBS CSI"
  default = "v1.30.0-eksbuild.1"
}


