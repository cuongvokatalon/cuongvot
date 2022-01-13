##############################
# Variables
##############################

variable "region" {
  default = "us-east-1"
}

variable "customer_name" {
  default = "katalon-dummy-tenant"
}

variable "private_instance_account" {
  type = map(string)
  default = {
    "customer" = "133729050265"
  }
}

variable "email" {
  default = "tech@katalon.com"
}

variable "name" {
  default = "Katalon"
}

variable "project_name" {
  description = "Name of project."
  default     = "katalon-testops"
}

variable "project_environment" {
  description = "Environment of project."
  default     = "dev-test"
}

variable "iam_user_access_to_billing" {
  default = "true"
}

variable "parent_id" {
  default = ""
}

variable "beanstalkRole" {
  default = ""
}

variable "application_name" {
  default = "katalon-analytics"
}

variable "applicationDescription" {
  default = ""
}

variable "environment" {
  default = "dummy-testops-environment"
}

variable "environmentId" {
  default = ""
}
variable "environmentConfigTemplateDescription" {
  default = ""
}

variable "environmentVariables" {
  type = list(object({
    namespace = string
    name = string
    value = string
  }))
  default = [ ]
}

variable "autoscalingVariables" {
  type = list(object({
    namespace = string
    name = string
    resource = string
    value = string
  }))
  default = [
    {
      namespace = "aws:autoscaling:asg"
      name      = "Availability Zones"
      resource  = "AWSEBAutoScalingGroup"
      value     = "Any"
    }
  ]
}

variable "tags" {
  default = {
    Project = "TestOps",
    env = "katalon-analytics-dummy",
    service = "TestOps",
    Customer = "DummyCorp"
  }
}

variable "testopsDatabaseClusterDBName" {
  default = "kan"
}

variable "testopsDatabaseInstanceEngine" {
  default = "aurora-postgresql"
}

# variable "testopsDatabaseInstanceSize" {  # Moved in to module katalon-rds-cluster
#   default = "db.r5.xlarge"
# }

variable "testopsDatabaseIntanceEngineVersion" {
  default = "12.6"
}

variable "database_enhanced_monitoring_role_name" {
  default = "TestOpsRDSEnhancedMonitoringRole"
}

variable "application_tags" {
  default = {
    Stage = "Production"
  }
}

variable "ec2_key_name" {
  default = "DummyKeyPair"
}

variable "environmentName" {
  default = "dummy-katalon-testops-io-production-waf"
}

variable "tier" {
  default = "WebServer"
}

variable "cnamePrefix" {
  default = "dummy-katalon"
}

variable "solution_stack_name" {
    default = "64bit Amazon Linux 2018.03 v2.11.11 running Java 8"
}

variable "maxCount" {
  default = "2"
}

variable "minAsgSize" {
  default = "0"
}

variable "maxAsgSize" {
  default = "1"
}

variable "securityGroups" {
  default = ""
}

variable "instanceProfile" {
  default = ""
}

variable "instanceType" {
  default = ""
}

variable "environmentTier" {
  default = ""
}

variable "cname_prefix" {
  default = ""
}

variable "katalon-testops-admin-production-waf" {
  type = map(string)
  default = {
    name                = "katalon-testops-admin-production-waf"
    description         = "License Server Production"
    tier                = "WebServer"
    cname_prefix        = "dummy-katalon-testops-admin-production-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "katalon_testops_io_production_waf" {
  type = map(string)
  default = {
    name                = "katalon-testops-admin-production-waf"
    description         = "License Server Production"
    tier                = "WebServer"
    cname_prefix        = "dummy-katalon-testops-admin-production-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "katalon-testops-pre-waf" {
  type = map(string)
  default = {
    name = "dummy-katalon-testops-pre-waf"
    description = "Clone of katalon-testops-production-waf"
    tier = "WebServer"
    cname_prefix = "dummy-katalon-testops-pre-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "katalon-testops-production-waf" {
  type = map(string)
  default = {
    name = "dummy-katalon-testops-production-waf"
    description = "katalon testops io production"
    tier = "WebServer"
    cname_prefix = "dummy-katalon-testops-production-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}
variable "katalon-testops-production-queue-waf" {
  type = map(string)
  default = {
    name = "dummy-katalon-testops-production-queue-waf"
    description = "katalon testops io production"
    tier = "WebServer"
    cname_prefix = "katalon-testops-production-queue-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

# Define policy ARNs as list
variable "ebs_iam_policy_arns" {
  description = "IAM Policies to be attached to EBS role"
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    # "arn:aws:iam::aws:policy/AmazonEC2RoleforSSM", TODO: is this a user-managed?
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
  ]
}

#
# msk
#
variable "msk_cluster_name" {
  default = "TestOps"
}
variable "msk_kafka_version" {
  default = "2.8.1"
}
variable "msk_number_of_broker_nodes" {
  default = "6"
}

variable "msk_instance_type" {
  default = "kafka.m5.large"
}

variable "msk_ebs_volume_size" {
  default = "1000"
}

variable "vpcID" {
  default = ""
}

variable "vpcName" {
  default = "VPC for TestOps Private Tenant"
}

variable "vpcCidr" {
  default = "10.0.0.0/16"
}

variable "subnets" {
  default = ""
}

# availability zones

variable "availability_zone_1" {
  default = "us-east-1a"
}
variable "availability_zone_2" {
  default = "us-east-1b"
}
variable "availability_zone_3" {
  default = "us-east-1c"
}

# private subnets

variable "private_subnet_1" {
  default = "10.0.1.0/24"
}
variable "private_subnet_2" {
  default = "10.0.2.0/24"
}
variable "private_subnet_3" {
  default = "10.0.3.0/24"
}

# public subnets

variable "public_subnet_1" {
  default = "10.0.101.0/24"
}
variable "public_subnet_2" {
  default = "10.0.102.0/24"
}
variable "public_subnet_3" {
  default = "10.0.103.0/24"
}

# dmz subnets

variable "dmz_subnet_1" {
  default = "us-east-1c"
}
variable "dmz_subnet_2" {
  default = "us-east-1c"
}
variable "dmz_subnet_3" {
  default = "us-east-1c"
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}
