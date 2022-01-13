##############################
# VPC
##############################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                                 = var.vpcName
  cidr                                 = var.vpcCidr
  azs                                  = [var.availability_zone_1, var.availability_zone_2, var.availability_zone_3]
  private_subnets                      = [var.private_subnet_1, var.private_subnet_2, var.private_subnet_3]
  public_subnets                       = [var.public_subnet_1, var.public_subnet_2, var.public_subnet_3]
  database_subnets                     = ["10.0.21.0/24", "10.0.22.0/24"]
  # dmz_subnets = ["${var.dmz_subnet_1}","${var.dmz_subnet_2}","${var.dmz_subnet_3}"]
  enable_nat_gateway                   = true
  enable_vpn_gateway                   = true
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  create_igw                           = true
  instance_tenancy                     = "default"
  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group        = true
  default_security_group_ingress       = []
  default_security_group_egress        = []
  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  tags                                 = var.tags
}