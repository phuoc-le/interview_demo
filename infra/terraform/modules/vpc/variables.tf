variable "env" {
  type        = string
  description = "Environment"
  default     = null
}

variable "cidrs" {
  type        = string
  description = "CIDR values"
  default     = null
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = null
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
  default     = null
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = []
}

variable "eks_worker_subnet_cidrs" {
  type        = list(string)
  description = "EKS Private Subnet CIDR values"
  default     = []
}

variable "eks_control_plane_subnet_cidrs" {
  type        = list(string)
  description = "EKS Private Subnet CIDR values"
  default     = []
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = []
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostnames"
  default     = true
}
variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS Support"
  default     = true
}