##############################
# S3
##############################

module "s3" {
  source                   = "./s3"
  tags                     = var.tags
  customer_name            = var.customer_name
  private_instance_account = { "customer" = "$var.private_instance_account" }

}