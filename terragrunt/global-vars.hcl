locals {
  app_name = "AzureMLOps" #$REPLACE: Adapt to your needs. Changing this after resource creation forces a new resource to be created!
  
  tags = {
    Owner       = local.app_name
    Project     = local.app_name
    Toolkit     = "terraform"   
  }

  allowedIpCidr = []
}
