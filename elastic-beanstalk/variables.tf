#
# variables.tf
#

variable "region" {
  default = "us-east-1"
}

variable "application_name" {
  type = string
  default = "katalon-analytics-peter"
}

variable "tags" {
  default = {
    Project  = "TestOps",
    env      = "katalon-analytics-dummy-peter",
    service  = "TestOps",
    Customer = "DummyCorp"
  }
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
  default = "aws-elasticbeanstalk-ec2-role-instance-profile"
}

variable "aws-elasticbeanstalk-ec2-role-instance-profile-name" {
  default = "aws-elasticbeanstalk-ec2-role-instance-profile"
}

variable "instanceType" {
  default = ""
}

variable "environmentTier" {
  default = ""
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

variable "application_description" {
  description = "The elastic beanstalk application "
  type        = string
  default     = ""
}

variable "application_tags" {
  type = map(string)
  default = {
    Stage = "Dummy-Tenant"
  }
}

variable "katalon_testops_admin_production_waf" {
  type = map(string)
  default = {
    name                = "katalon-testops-admin-production-waf-peter"
    description         = "License Server Production"
    tier                = "WebServer"
    cname_prefix        = "dummy-katalon-testops-admin-production-waf-peter"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "katalon_testops_io_production_waf" {
  type = map(string)
  default = {
    name                = "katalon-testops-admin-production-waf-peter"
    description         = "License Server Production"
    tier                = "WebServer"
    cname_prefix        = "dummy-katalon-testops-admin-production-waf-peter"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "katalon_testops_pre_waf" {
  type = map(string)
  default = {
    name = "dummy-katalon-testops-pre-waf-peter"
    description = "Clone of katalon-testops-production-waf"
    tier = "WebServer"
    cname_prefix = "dummy-katalon-testops-pre-waf-peter"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "katalon_testops_production_waf" {
  type = map(string)
  default = {
    name = "dummy-katalon-testops-production-waf-peter"
    description = "katalon testops io production"
    tier = "WebServer"
    cname_prefix = "dummy-katalon-testops-production-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}
variable "katalon_testops_production_queue_waf-peter" {
  type = map(string)
  default = {
    name = "dummy-katalon-testops-production-queue-waf"
    description = "katalon testops io production"
    tier = "WebServer"
    cname_prefix = "katalon-testops-production-queue-waf"
    solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  }
}

variable "vpcID" {
  default = "vpc-07073eb719d983655"
}

variable "vpcName" {
  default = "VPC for TestOps Private Tenant"
}

variable "vpcCidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ""
}

variable "public_subnets" {
  default = ""
}
