##############################
# Main
##############################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#
# resource groups
#
resource "aws_resourcegroups_group" "ResourceGroupsGroup" {
  name        = "TestOps"
  description = "Group by TestOps Project"
  resource_query {
    type  = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters = [ "AWS::AllSupported" ]
      TagFilters = [
        {
          Key = "Project"
          Values = [ "TestOps" ]
        }
      ]
    })
  }
}


##############
# IAM
##############
resource "aws_iam_user" "katalonadmin" {
  path = "/"
  name = "katalonadmin"
  tags = var.tags
}

resource "aws_iam_role" "IAMRole" {
  path                 = "/"
  name                 = "AWS-CodePipeline-Service"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"codepipeline.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = var.tags
}

resource "aws_iam_user" "TestopsSmtpIAMUser" {
  path = "/"
  name = "testops-smtp"
  tags = var.tags
}

resource "aws_iam_user_policy" "TestopsSmtpUserIAMPolicy" {
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ses:SendRawEmail"
        Resource = "*"
      }
    ]
  })
  user   = aws_iam_user.TestopsSmtpIAMUser.name
}

/**
***  feature/CO-39-testops-msk-cluster
**/
module "msk-cluster" {
  source = "./msk-cluster"
  cluster_name    = var.msk_cluster_name
  instance_type   = "kafka.m5.large"
  number_of_nodes = var.msk_number_of_broker_nodes
  client_subnets  = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  kafka_version   = var.msk_kafka_version
  enhanced_monitoring = "PER_BROKER"
  #  s3_logs_bucket = aws_s3_bucket.logs.id
  s3_logs_prefix = "msklogs"

}

#
# lambda
#

module "lambda" {
  depends_on  = [module.vpc]
  source = "./lambda"
  testops_engine_subnet_ids = module.vpc.private_subnets
}

#
# rds
#
module "rds" {
  depends_on = [module.vpc]
  #source = "git@github.com:hashicorp/example.git?ref=develop"
  # source = "git@github.com:katalon-studio/katalon-iac.git//terraform//katalon-rds-cluster?ref=develop"
  source = "./katalon-rds-cluster"

  namespace    = "katalon"
  environment  = ""
  stage        = "private-instance"
  name         = "testops-production-aurora-12-6"
  tags         = {
    Name       = "testops"
  }
  vpc_id        =  module.vpc.vpc_id
  subnets       =  module.vpc.database_subnets
  instance_type = "db.r6g.xlarge"
  db_name       = "testopsProductionAurora126ok"
  source_region = "us-east-1"
  vpc_security_group_ids = [module.vpc.default_security_group_id,module.vpc.default_vpc_default_security_group_id]
  instance_availability_zone = "us-east-1a"
  #db-subnet-group-name = "testops-private-subnet-group"
  db-subnet-group-name = module.vpc.database_subnet_group_name
}

##############################
# elastic beanstalk
##############################
module "elastic-beanstalk" {
  depends_on  = [module.vpc, module.rds]
  source = "./elastic-beanstalk"
  application_name = var.application_name
  tags = merge(var.tags, var.application_tags)
  #
  #  appName = var.appName
  #  beanstalkRole = var.beanstalkRole
  #  cnamePrefix = var.cnamePrefix
  #  environment = var.environment
  #  environmentName = var.environmentName
  #  region = var.region
  #  #workspace = var.workspace
  #  minAsgSize = var.minAsgSize
  #  maxAsgSize = var.maxAsgSize
  securityGroups = aws_security_group.katalon-testops-io-production-waf-sg.id
  #  instanceType = var.instanceType
  #  instanceProfile = var.instanceProfile
  #  tags = var.tags
  #
  vpcID = module.vpc.vpc_id
  #vpcIDName = module.vpc.vpc_id
  private_subnets = "${module.vpc.private_subnets[0]},${module.vpc.private_subnets[1]},${module.vpc.private_subnets[2]}"
  public_subnets = "${module.vpc.public_subnets[0]},${module.vpc.public_subnets[1]},${module.vpc.public_subnets[2]}"
}


resource "aws_iam_role" "testops_rds_enhanced_monitoring" {
  name        = var.database_enhanced_monitoring_role_name
  assume_role_policy = data.aws_iam_policy_document.testops_rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "testops_rds_enhanced_monitoring" {
  role       = aws_iam_role.testops_rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "testops_rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

