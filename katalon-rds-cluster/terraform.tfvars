namespace    = "katalon"
environment  = ""
stage        = ""
name         = "testops-production-aurora-12-6-peter"
tags         = {
  Name       = "testops-peter"
}
vpc_id        =  "vpc-5b67113c"
subnets       =  ["subnet-f6858bae", "subnet-baeb12f3", "subnet-00ca109ed5bdac551"]
# instance_type = "db.r6g.xlarge"
instance_type = "db.t3.medium"  # Temp for saving cost during testing.
db_name       = "testopsProductionAurora126okpeter"
source_region = "us-east-1"
vpc_security_group_ids = ["sg-06fac3390239ccb17", "sg-4ade5a3a"]
security_groups = ["sg-06fac3390239ccb17", "sg-4ade5a3a"]
# instance_availability_zone = "us-east-1a" #current not in used
db-subnet-group-name = "testops-private-subnet-group"
