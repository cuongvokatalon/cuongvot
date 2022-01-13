##############################
# Code Build
##############################

# Code Build project # CO-119-iac-testops-code
module "katalon-testops-queue-codebuild" {
  source         = "./code-build"
  #S3 bucket name for CodeBuild
  bucket         = "codebuild-testz"
  private_subnets = module.vpc.private_subnets
  codebuild-security-groups = [aws_security_group.katalon-tools-sg.id] # placeholder

  # s3_location = aws_s3_bucket.katalon
  #acl is private in default
  #CodeBuild
  name           = "test-codebuild-project"
  description    = "description_test_codebuild_project"
  # badge_enabled = "false"
  build_timeout  = "5"
     #service_role  = aws_iam_role.IAMRole21.arn
     service_role   = "arn:aws:iam::133729050265:role/service-role/codebuild-Katalon-Testops-ConfigServer-service-role"

  queued_timeout = 5
  # No Artifacts

  # Source
  # codebuild_source_version = "master"
  source_type              = "CODECOMMIT"
  source_location          = module.katalon-testops-queue-codecommit.clone_url_http #Default same is codebuild repo
  git_clone_depth          = 0


  # Secondary source
  # secondary_source_version = "master"
  secondary_source_type       = "CODECOMMIT"
  secondary_source_location   = module.katalon-testops-queue-secondary-codecommit.clone_url_http
  #Default same is codebuild repo
  secondary_git_clone_depth   = 0
  secondary_source_identifier = "Test"

  # Cache
  cache_type     = "S3"
  cache_location = module.s3.code-build-cache

  # Cloudwatch Logs
  # cloudwatch_logs_status = "ENABLED"
  # S3 Logs
  s3_logs_status = "ENABLED"

  # VPC config
  vpc_id = module.vpc.vpc_id

  # Environment configuration
  environment = {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    # Environment variables
    variables = [
      {
        name  = "ENV"
        value = "test-environment"
      },
      {
        name  = "examplekey"
        value = "examplevalue"
      },
      {
        name  = "examplekey2"
        value = "examplevalue2"
      },
    ]
  }

  tags = {
    Environment = "Test-develop"
  }
}
