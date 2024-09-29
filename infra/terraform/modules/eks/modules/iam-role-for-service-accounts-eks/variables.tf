variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = null
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "policy_name_prefix" {
  description = "IAM policy name prefix"
  type        = string
  default     = "AmazonEKS_"
}

variable "role_policy_arns" {
  description = "ARNs of any policies to attach to the IAM role"
  type        = map(string)
  default     = {}
}

variable "oidc_providers" {
  description = "Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts`"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to add the the IAM role"
  type        = map(any)
  default     = {}
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "assume_role_condition_test" {
  description = "Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role"
  type        = string
  default     = "StringEquals"
}

variable "allow_self_assume_role" {
  description = "Determines whether to allow the role to be [assume itself](https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/)"
  type        = bool
  default     = false
}

################################################################################
# Policies
################################################################################

# Cert Manager
variable "attach_cert_manager_policy" {
  description = "Determines whether to attach the Cert Manager IAM policy to the role"
  type        = bool
  default     = false
}

variable "cert_manager_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs to allow Cert manager to manage records"
  type        = list(string)
  default     = ["arn:aws:route53:::hostedzone/*"]
}

# Cluster autoscaler
variable "attach_cluster_autoscaler_policy" {
  description = "Determines whether to attach the Cluster Autoscaler IAM policy to the role"
  type        = bool
  default     = false
}

variable "cluster_autoscaler_cluster_ids" {
  description = "List of cluster IDs to appropriately scope permissions within the Cluster Autoscaler IAM policy"
  type        = list(string)
  default     = []
}

# EBS CSI
variable "attach_ebs_csi_policy" {
  description = "Determines whether to attach the EBS CSI IAM policy to the role"
  type        = bool
  default     = false
}

variable "ebs_csi_kms_cmk_ids" {
  description = "KMS CMK IDs to allow EBS CSI to manage encrypted volumes"
  type        = list(string)
  default     = []
}

# EFS CSI
variable "attach_efs_csi_policy" {
  description = "Determines whether to attach the EFS CSI IAM policy to the role"
  type        = bool
  default     = false
}

# AWS Load Balancer Controller
variable "attach_load_balancer_controller_policy" {
  description = "Determines whether to attach the Load Balancer Controller policy to the role"
  type        = bool
  default     = false
}

variable "attach_load_balancer_controller_targetgroup_binding_only_policy" {
  description = "Determines whether to attach the Load Balancer Controller policy for the TargetGroupBinding only"
  type        = bool
  default     = false
}

# VPC CNI
variable "attach_vpc_cni_policy" {
  description = "Determines whether to attach the VPC CNI IAM policy to the role"
  type        = bool
  default     = false
}

variable "vpc_cni_enable_ipv4" {
  description = "Determines whether to enable IPv4 permissions for VPC CNI policy"
  type        = bool
  default     = false
}

variable "vpc_cni_enable_ipv6" {
  description = "Determines whether to enable IPv6 permissions for VPC CNI policy"
  type        = bool
  default     = false
}

# Node termination handler
variable "attach_node_termination_handler_policy" {
  description = "Determines whether to attach the Node Termination Handler policy to the role"
  type        = bool
  default     = false
}

variable "node_termination_handler_sqs_queue_arns" {
  description = "List of SQS ARNs that contain node termination events"
  type        = list(string)
  default     = ["*"]
}