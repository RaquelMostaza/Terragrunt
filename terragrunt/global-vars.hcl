locals {
  app_name = "AzureMLOps" #$REPLACE: Adapt to your needs. Changing this after resource creation forces a new resource to be created!
  source_base_url = "git::ssh://git@atc-github.azure.cloud.bmw/Data-Transformation-AI/aip-azure-mlops-infrastructure-modules.git//infrastructure//modules//"
  
  tags = {
    Owner       = local.app_name
    Project     = local.app_name
    Toolkit     = "terraform"   
  }

  allowedIpCidr = ["160.46.252.0/24","104.209.111.0/24","104.209.113.0/24","193.23.33.0/24","193.23.38.0/24","193.23.32.0/24","160.48.234.0/24","170.34.104.0/24","51.116.254.0/23"]
}
