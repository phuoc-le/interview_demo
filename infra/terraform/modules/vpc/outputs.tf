output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets as list"
  value       = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets as list"
  value       = aws_subnet.public_subnets.*.id
}

output "eks_worker_subnet_ids" {
  description = "The IDs of the eks worker private subnets as list"
  value       = aws_subnet.eks_worker_subnets.*.id
}

output "eks_control_plane_subnet_ids" {
  description = "The IDs of the eks control plane private subnets as list"
  value       = aws_subnet.eks_control_plane_subnets.*.id
}
