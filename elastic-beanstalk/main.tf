#locals {
#  server_properties = join("\n", [for k, v in var.server_properties : format("%s = %s", k, v)])
#  enable_logs       = var.s3_logs_bucket != "" || var.cloudwatch_logs_group != "" || var.firehose_logs_delivery_stream != "" ? ["true"] : []
#}  adsds

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) Multi-container Docker (.*)$"
}

resource "aws_elastic_beanstalk_application" "this" {
  name        = var.application_name
  # should be katalon-analytics, which is the *original* name for TestOps, per product team
  description = var.application_description
  tags        = merge(var.tags, var.application_tags)
  # tags_all    = merge(var.tags, var.application_tags)

  appversion_lifecycle {
    #service_role          = aws_iam_role.beanstalk_service.arn
    #service_role          = aws_iam_role.katalon-testops-elasticbeanstalk-role.arn
    service_role          = "arn:aws:iam::133729050265:role/aws-elasticbeanstalk-service-role"
    # service_role          = "arn:aws:iam::133729050265:role/AWSServiceRoleForElasticBeanstalk"
    # service_role = aws_iam_service_linked_role.katalon-testops-elasticbeanstalk-service-role.arn
    max_count             = var.maxCount
    max_age_in_days       = 0
    # max_count             = 100
    # max_age_in_days       = var.maxAgeInDays
    delete_source_from_s3 = false
  }
  //depends_on = [
  //  aws_iam_service_linked_role.katalon-testops-elasticbeanstalk-service-role,
  //  aws_iam_policy.MemoryUsageForEB-Cloudwatch,
  //]
}

resource "aws_elastic_beanstalk_environment" "testops-waf-peter" {
  name                = "katalon-testops-production-waf-peter"
  application         = aws_elastic_beanstalk_application.this.name
  # solution_stack_name = "64bit Amazon Linux 2 v3.2.8 running Corretto 8"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.16 running Java 8"
  # PlatformArn: arn:aws:elasticbeanstalk:us-east-1::platform/Java 8 running on 64bit Amazon Linux/2.11.16
  # SolutionStackName: 64bit Amazon Linux 2018.03 v2.11.16 running Java 8

  setting {
    name      = "AccessLogsS3Enabled"
    namespace = "aws:elbv2:loadbalancer"
    value     = "false"
  }

  setting {
    name      = "AppSource"
    namespace = "aws:cloudformation:template:parameter"
    # value = "https://elasticbeanstalk-platform-assets-us-east-1.s3.amazonaws.com/stalks/eb_docker_amazon_linux_2_1.0.1749.0_20211118032146/sampleapp/EBSampleApp-Docker.zip"
    # value     = "s3://katalon-one-dummy-tenant-build/testops-deployment-package.zip"
    # value     = "https://elasticbeanstalk-samples-us-east-1.s3.amazonaws.com/java-sample-app-v3.zip"
    value     = "https://elasticbeanstalk-us-east-1-133729050265.s3.amazonaws.com/20220138CL-test.zip" # Test login-page-manually-successed_package
  }

  setting {
    name      = "Automatically Terminate Unhealthy Instances"
    namespace = "aws:elasticbeanstalk:monitoring"
    value     = "true"
  }
  setting {
    name      = "Availability Zones"
    namespace = "aws:autoscaling:asg"
    resource  = "AWSEBAutoScalingGroup"
    value     = "Any"
  }
  setting {
    name      = "BatchSize"
    namespace = "aws:elasticbeanstalk:command"
    value     = "100"
  }
  setting {
    name      = "BatchSizeType"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Percentage"
  }

  setting {
    name      = "BreachDuration"
    namespace = "aws:autoscaling:trigger"
    value     = "5"
  }

  setting {
    name      = "Cooldown"
    namespace = "aws:autoscaling:asg"
    resource  = "AWSEBAutoScalingGroup"
    value     = "360"
  }

  setting {
    name      = "DefaultProcess"
    namespace = "aws:elbv2:listener:default"
    value     = "default"
  }
  setting {
    name      = "DefaultSSHPort"
    namespace = "aws:elasticbeanstalk:control"
    value     = "22"
  }
  setting {
    name      = "DeleteOnTerminate"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value     = "false"
  }
  setting {
    name      = "DeleteOnTerminate"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    value     = "false"
  }
  setting {
    name      = "DeploymentPolicy"
    namespace = "aws:elasticbeanstalk:command"
    value     = "AllAtOnce"
  }
  setting {
    name      = "DeregistrationDelay"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "20"
  }
  /*
  setting {
   name = "DisableIMDSv1"
   namespace = "aws:autoscaling:launchconfiguration"
   value = "true"
 }
 }*/
  setting {
    name      = "ELBScheme"
    namespace = "aws:ec2:vpc"
    value     = "public"
  }
  setting {
    name      = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value     = var.public_subnets
  }
  setting {
    name      = "EnableCapacityRebalancing"
    namespace = "aws:autoscaling:asg"
    resource  = "AWSEBAutoScalingGroup"
    value     = "false"
  }
  setting {
    name      = "EnableSpot"
    namespace = "aws:ec2:instances"
    value     = "false"
  }
  setting {
    name      = "EnhancedHealthAuthEnabled"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "true"
  }
  setting {
    name      = "EnvironmentType"
    namespace = "aws:elasticbeanstalk:environment"
    value     = "LoadBalanced"
  }

  setting {
    name      = "EvaluationPeriods"
    namespace = "aws:autoscaling:trigger"
    value     = "1"
  }

  setting {
    name      = "HasCoupledDatabase"
    namespace = "aws:rds:dbinstance"
    value     = "false"
  }
  setting {
    name      = "HealthCheckInterval"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "15"
  }
  setting {
    name      = "HealthCheckPath"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "/health-checker"
  }
  setting {
    name      = "HealthCheckSuccessThreshold"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "Ok"
  }
  setting {
    name      = "HealthCheckTimeout"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "5"
  }
  setting {
    name      = "HealthStreamingEnabled"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    value     = "false"
  }
  setting {
    name      = "HealthyThresholdCount"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "3"
  }

  setting {
    name      = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    resource  = "AWSEBAutoScalingLaunchConfiguration"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    name      = "IgnoreHealthCheck"
    namespace = "aws:elasticbeanstalk:command"
    value     = "true"
  }
  setting {
    name      = "ImageId"
    namespace = "aws:autoscaling:launchconfiguration"
    resource  = "AWSEBAutoScalingLaunchConfiguration"
    value     = "ami-0b8cc8df92337db48"
  }
  setting {
    name      = "InstancePort"
    namespace = "aws:cloudformation:template:parameter"
    value     = "80"
  }
  setting {
    name      = "InstanceRefreshEnabled"
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    value     = "false"
  }
  setting {
    name      = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = "t2.micro"
  }
  setting {
    name      = "InstanceTypeFamily"
    namespace = "aws:cloudformation:template:parameter"
    value     = "t2"
  }
  setting {
    name      = "LaunchTimeout"
    namespace = "aws:elasticbeanstalk:control"
    value     = "0"
  }
  setting {
    name      = "LaunchType"
    namespace = "aws:elasticbeanstalk:control"
    value     = "Migration"
  }
  setting {
    name      = "ListenerEnabled"
    namespace = "aws:elbv2:listener:default"
    value     = "true"
  }
  setting {
    name      = "LoadBalancerIsShared"
    namespace = "aws:elasticbeanstalk:environment"
    value     = "false"
  }
  setting {
    name      = "LoadBalancerType"
    namespace = "aws:elasticbeanstalk:environment"
    value     = "application"
  }
  setting {
    name      = "LogPublicationControl"
    namespace = "aws:elasticbeanstalk:hostmanager"
    value     = "false"
  }
  setting {
    name      = "LowerBreachScaleIncrement"
    namespace = "aws:autoscaling:trigger"
    value     = "-1"
  }
  setting {
    name      = "LowerThreshold"
    namespace = "aws:autoscaling:trigger"
    value     = "20"
  }
  setting {
    name      = "ManagedActionsEnabled"
    namespace = "aws:elasticbeanstalk:managedactions"
    value     = "false"
  }

  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asg"
    resource  = "AWSEBAutoScalingGroup"
    value     = "4"
  }
  setting {
    name      = "MeasureName"
    namespace = "aws:autoscaling:trigger"
    value     = "HealthyHostCount"
  }
  setting {
    name      = "MinInstancesInService"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "1"
  }
  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asg"
    resource  = "AWSEBAutoScalingGroup"
    value     = "1"
  }
  setting {
    name      = "MonitoringInterval"
    namespace = "aws:autoscaling:launchconfiguration"
    resource  = "AWSEBAutoScalingLaunchConfiguration"
    value     = "5 minute"
  }

  setting {
    name      = "Notification Protocol"
    namespace = "aws:elasticbeanstalk:sns:topics"
    value     = "email"
  }

  setting {
    name      = "Period"
    namespace = "aws:autoscaling:trigger"
    value     = "5"
  }
  setting {
    name      = "Port"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "5000"
  }
  setting {
    name      = "Protocol"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "HTTP"
  }
  setting {
    name      = "Protocol"
    namespace = "aws:elbv2:listener:default"
    value     = "HTTP"
  }

  setting {
    name      = "RetentionInDays"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value     = "7"
  }
  setting {
    name      = "RetentionInDays"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    value     = "7"
  }
  setting {
    name      = "RollbackLaunchOnFailure"
    namespace = "aws:elasticbeanstalk:control"
    value     = "false"
  }
  setting {
    name      = "RollingUpdateEnabled"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "false"
  }
  setting {
    name      = "RollingUpdateType"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "Time"
  }

  setting {
    name      = "RootVolumeType"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = "standard"
  }

  setting {
    name      = "SSHSourceRestriction"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = "tcp,22,22,0.0.0.0/0"
  }
  setting {
    name      = "SSLPolicy"
    namespace = "aws:elbv2:listener:443"
    value     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = var.securityGroups
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "DefaultProcess"
    resource  = "AWSEBV2LoadBalancerListener443"
    value     = "default"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    resource  = "AWSEBV2LoadBalancerListener443"
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    resource  = "AWSEBV2LoadBalancerListener443"
    value     = "HTTPS"
  }
  setting {
    name      = "SSLCertificateArns"
    namespace = "aws:elbv2:listener:443"
    value     = "arn:aws:acm:us-east-1:133729050265:certificate/bed87688-974a-4923-b3d5-7d5c659648d8"
  }
  setting {
    name      = "SecurityGroups"
    namespace = "aws:elbv2:loadbalancer"
    value     = var.securityGroups
  }
  setting {
    name      = "ServiceRole"
    namespace = "aws:elasticbeanstalk:environment"
    value     = "aws-elasticbeanstalk-service-role"
  }
  /*
  setting {
    name      = "ServiceRoleForManagedUpdates"
    namespace = "aws:elasticbeanstalk:managedactions"
    value     = "aws-elasticbeanstalk-service-role"
  }
  */
  setting {
    name      = "SpotFleetOnDemandAboveBasePercentage"
    namespace = "aws:ec2:instances"
    value     = "70"
  }
  setting {
    name      = "SpotFleetOnDemandBase"
    namespace = "aws:ec2:instances"
    value     = "0"
  }

  setting {
    name      = "Statistic"
    namespace = "aws:autoscaling:trigger"
    value     = "Average"
  }
  setting {
    name      = "StickinessEnabled"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "false"
  }
  setting {
    name      = "StickinessLBCookieDuration"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "86400"
  }
  setting {
    name      = "StickinessType"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "lb_cookie"
  }
  setting {
    name      = "StreamLogs"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value     = "true"
  }
  setting {
    name      = "Subnets"
    namespace = "aws:ec2:vpc"
    value     = var.private_subnets
  }
  setting {
    name      = "SupportedArchitectures"
    namespace = "aws:ec2:instances"
    value     = "x86_64"
  }
  setting {
    name      = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "enhanced"
  }
  setting {
    name      = "Timeout"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "PT30M"
  }
  setting {
    name      = "Timeout"
    namespace = "aws:elasticbeanstalk:command"
    value     = "600"
  }
  setting {
    name      = "UnhealthyThresholdCount"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "5"
  }
  setting {
    name      = "Unit"
    namespace = "aws:autoscaling:trigger"
    value     = "Percent"
  }

  setting {
    name      = "UpperBreachScaleIncrement"
    namespace = "aws:autoscaling:trigger"
    value     = "1"
  }
  setting {
    name      = "UpperThreshold"
    namespace = "aws:autoscaling:trigger"
    value     = "50"
  }
  setting {
    name      = "VPCId"
    namespace = "aws:ec2:vpc"
    value     = var.vpcID
  }
  setting {
    name      = "XRayEnabled"
    namespace = "aws:elasticbeanstalk:xray"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "GRADLE_HOME"
    value     = "/usr/local/gradle"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JAVA_HOME"
    value     = "/usr/lib/jvm/java"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KATALON_JVM_OPTIONS"
    value     = "-Xmx15360m -Dfile.encoding=UTF-8 -Dlog4j2.formatMsgNoLookups=true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_LOG_FOLDER"
    value     = "/var/log/testops"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "M2"
    value     = "/usr/local/apache-maven/bin"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "M2_HOME"
    value     = "/usr/local/apache-maven"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_DATASOURCE_PASSWORD"
    value     = "V_]MXGP=&'U8"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_DATASOURCE_USERNAME"
    value     = "root"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "fixed,aws,production,production-io"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ZUUL_HOST_CONNECT_TIMEOUT_MILLIS"
    value     = "300000"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ZUUL_HOST_SOCKET_TIMEOUT_MILLIS"
    value     = "300000"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    resource  = "AWSEBAutoScalingLaunchConfiguration"
    value     = "katalon-single-tenant-test"
  }

  setting {
    namespace = "aws:cloudformation:template:parameter"
    name      = "EnvironmentVariables"
    value     = "M2=/usr/local/apache-maven/bin,ZUUL_HOST_CONNECT_TIMEOUT_MILLIS=300000,SPRING_DATASOURCE_PASSWORD=V_]MXGP=&'U8,M2_HOME=/usr/local/apache-maven,SPRING_PROFILES_ACTIVE=fixed,aws,production,proxy,JAVA_HOME=/usr/lib/jvm/java,SPRING_DATASOURCE_USERNAME=root,KIT_SERVER_URL=https://analytics.katalon-cloudops.com,ZUUL_HOST_SOCKET_TIMEOUT_MILLIS=300000,KIT_LOG_FOLDER=/var/log/testops,KATALON_JVM_OPTIONS=-Xmx15360m -Dfile.encoding=UTF-8 -Dlog4j2.formatMsgNoLookups = true,GRADLE_HOME = /usr/local/gradle"
  }
  /*
  setting {
  namespace = "aws:cloudformation:template:parameter"
  name = "HooksPkgUrl"
  value = "https://s3.dualstack.us-east-1.amazonaws.com/elasticbeanstalk-env-resources-us-east-1/stalks/eb_java_1.0.203027.0_1640305442/lib/hooks.tar.gz"
  }
  */
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "c3.large"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    resource  = "AWSEBAutoScalingLaunchConfiguration"
    value     = "false"
  }
  /*
setting {
namespace = "aws:elasticbeanstalk:application"
name = "Application Healthcheck URL"
value = ""
}
^
*/
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "GRADLE_HOME"
    value     = "/usr/local/gradle"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JAVA_HOME"
    value     = "/usr/lib/jvm/java"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KATALON_JVM_OPTIONS"
    #value     = "-Xmx15360m -Dfile.encoding=UTF-8 -Dlog4j2.formatMsgNoLookups=true"
    value     = "-Xmx3072m -Dfile.encoding=UTF-8"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KATONE_ADMIN_EMAIL"
    value     = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KATONE_ADMIN_PASSWORD"
    value     = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_AUTHENTICATION_SP"
    value     = "dcae5593ee8072e46d9b790687d66edf7eba904360c9dcbf9cfe519d1ae67326"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_DATABASE_HOST"
    value     = "login-page-manually-aurora-postgre-rds-1.cluster-cinc7b4hb0ns.us-east-1.rds.amazonaws.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_DATABASE_READONLY_HOST"
    value     = "login-page-manually-aurora-postgre-rds-1.cluster-cinc7b4hb0ns.us-east-1.rds.amazonaws.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_KAFKA_BOOTSTRAP_SERVERS"
    value     = "b-4.testops.xmcoza.c21.kafka.us-east-1.amazonaws.com:9094"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_LOG_FOLDER"
    value     = "/var/log/testops"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_READONLY_DATASOURCE_PASSWORD"
    value     = "testops2022"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_READONLY_DATASOURCE_USERNAME"
    value     = "postgres"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_SAML_BASE_URL"
    value     = "https://testops-private.katalon-cloudops.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LICENSE_SERVER_URL"
    value     = "login-page.us-east-1.elasticbeanstalk.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PROXY_TUNNEL_CLI_RELEASE"
    value     = "https://github.com/katalon-studio/katalon-proxy-tunnel-client-dev/releases/download"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PROXY_TUNNEL_CLI_VERSION"
    value     = "v1.0.2"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KIT_SERVER_URL"
    value     = "https://analytics.katalon-cloudops.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "M2"
    value     = "/usr/local/apache-maven/bin"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "M2_HOME"
    value     = "/usr/local/apache-maven"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_DATASOURCE_PASSWORD"
    value     = "testops2022"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_DATASOURCE_USERNAME"
    value     = "postgres"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_MAIL_USERNAME"
    value     = "testops.katalon"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_MAIL_PASSWORD"
    value     = "fvZLiWQ4BGUtSx"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "fixed,listener,aws,staging"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "TEST_CLOUD_SERVER_URL"
    value     = "login-page.us-east-1.elasticbeanstalk.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ZUUL_HOST_CONNECT_TIMEOUT_MILLIS"
    value     = "300000"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ZUUL_HOST_SOCKET_TIMEOUT_MILLIS"
    value     = "300000"
  }
  setting {
    namespace = "aws:elasticbeanstalk:customoption"
    name      = "CloudWatchMetrics"
    value     = "--mem-util --mem-used --mem-avail --disk-space-util --disk-space-used --disk-space-avail --disk-path = / --auto-scaling"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "ConfigDocument"
    value     = "{\"Version\":1,\"CloudWatchMetrics\":{\"Instance\":{\"CPUIrq\":null,\"LoadAverage5min\":null,\"ApplicationRequests5xx\":null,\"ApplicationRequests4xx\":null,\"CPUUser\":null,\"LoadAverage1min\":null,\"ApplicationLatencyP50\":null,\"CPUIdle\":null,\"InstanceHealth\":null,\"ApplicationLatencyP95\":null,\"ApplicationLatencyP85\":null,\"RootFilesystemUtil\":null,\"ApplicationLatencyP90\":null,\"CPUSystem\":null,\"ApplicationLatencyP75\":null,\"CPUSoftirq\":null,\"ApplicationLatencyP10\":null,\"ApplicationLatencyP99\":null,\"ApplicationRequestsTotal\":null,\"ApplicationLatencyP99.9\":null,\"ApplicationRequests3xx\":null,\"ApplicationRequests2xx\":null,\"CPUIowait\":null,\"CPUNice\":null},\"Environment\":{\"InstancesSevere\":null,\"InstancesDegraded\":null,\"ApplicationRequests5xx\":null,\"ApplicationRequests4xx\":null,\"ApplicationLatencyP50\":null,\"ApplicationLatencyP95\":null,\"ApplicationLatencyP85\":null,\"InstancesUnknown\":null,\"ApplicationLatencyP90\":null,\"InstancesInfo\":null,\"InstancesPending\":null,\"ApplicationLatencyP75\":null,\"ApplicationLatencyP10\":null,\"ApplicationLatencyP99\":null,\"ApplicationRequestsTotal\":null,\"InstancesNoData\":null,\"ApplicationLatencyP99.9\":null,\"ApplicationRequests3xx\":null,\"ApplicationRequests2xx\":null,\"InstancesOk\":null,\"InstancesWarning\":null}}}"
  }
  /**
setting {
namespace = "aws:elasticbeanstalk:managedactions"
name = "PreferredStartTime"
}
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ServiceRoleForManagedUpdates"
    value     = "arn:aws:iam::133729050265:role/aws-elasticbeanstalk-service-role"
  }
**/
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = "false"
  }
  /*
setting {
namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
name = "UpdateLevel"
} */
  /*
setting {
namespace = "aws:elasticbeanstalk:sns:topics"
name = "Notification Endpoint"
}
setting {
namespace = "aws:elasticbeanstalk:sns:topics"
name = "Notification Protocol"
value = "email"
}
setting {
namespace = "aws:elasticbeanstalk:sns:topics"
name = "Notification Topic ARN"
}
setting {
namespace = "aws:elasticbeanstalk:sns:topics"
name = "Notification Topic Name"
}
setting {
namespace = "aws:elasticbeanstalk:trafficsplitting"
name = "EvaluationTime"
}
setting {
namespace = "aws:elasticbeanstalk:trafficsplitting"
name = "NewVersionPercent"
}
*/
  /*
setting {
namespace = "aws:elbv2:listener:443"
name = "Rules"
resource = "AWSEBV2LoadBalancerListener443"
}
*/
  /*
setting {
namespace = "aws:elbv2:listener:default"
name = "Rules"
resource = "AWSEBV2LoadBalancerListener"
}
setting {
namespace = "aws:elbv2:listener:default"
name = "SSLCertificateArns"
resource = "AWSEBV2LoadBalancerListener"
}
setting {
namespace = "aws:elbv2:listener:default"
name = "SSLPolicy"
resource = "AWSEBV2LoadBalancerListener"
}
setting {
namespace = "aws:elbv2:loadbalancer"
name = "AccessLogsS3Bucket"
resource = "AWSEBV2LoadBalancer"
}
*/

  /*
setting {
namespace = "aws:elbv2:loadbalancer"
name = "AccessLogsS3Prefix"
resource = "AWSEBV2LoadBalancer"
}
*/
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "IdleTimeout"
    resource  = "AWSEBV2LoadBalancer"
    value     = "3600"
  }
  /*
setting {
namespace = "aws:elbv2:loadbalancer"
name = "SecurityGroups"
resource = "AWSEBV2LoadBalancer"
value = "sg-008029f1b79109bc5"
}
*/

  tags = {
    # Name        = "test"  # Ticket can not edit current Name: https://github.com/hashicorp/terraform-provider-aws/issues/3963
    Environment = "test"
  }

}

/**
TODO: FIX SETTINGS
**/

resource "aws_iam_policy" "MemoryUsageForEB-Cloudwatch-peter" {
  name   = "MemoryUsageForEB-Cloudwatch"
  path   = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "ec2:DescribeSubnets"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
