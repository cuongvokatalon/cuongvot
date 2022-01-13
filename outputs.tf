#
# outputs.tf outputs for testops 
#

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "resource_groups_group" {
  description = "Group by TestOps Project"
  value = aws_resourcegroups_group.ResourceGroupsGroup
}

data "aws_caller_identity" "current" {}
output "account_id" {
 value = data.aws_caller_identity.current.account_id
}
output "caller_arn" {
value = data.aws_caller_identity.current.arn
}
output "caller_user" {
value = data.aws_caller_identity.current.user_id
}

/**
output "endpoint" {
  value = aws_eks_cluster.EKSCluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.EKSCluster.certificate_authority[0].data
}
**/
