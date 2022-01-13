##############################
# Backend configuration
##############################

terraform {
   backend "remote" {
      organization = "KatalonLLC" 
     
     workspaces {
         name = "testops-private-instance-workspace-tenant-1"
     }
  }
}
