##############################
# Code Commit
##############################

# CodeCommit Repo GIT # CO-119-iac-testops-code
module "katalon-testops-queue-codecommit" {
  source    = "./code-commit"
  repository_name = "testops-private-instance-test"
  description     = "this is repository of TestOps Private Test Instance"
}

module "katalon-testops-queue-secondary-codecommit" {
  source    = "./code-commit"
  repository_name = "testops-private-instance-test-secondary"
  description     = "this is repository of TestOps Private Instance Test Secondary"
}