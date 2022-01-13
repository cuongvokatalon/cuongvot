##############################
# Local Variables
##############################

locals {
  prefix_name      = "${var.project_name}-${var.project_environment}"
  tags               = var.tags
}