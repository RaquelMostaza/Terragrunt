# Terragrunt

        "typeProperties": {
            "subscriptionId": "6c8f484c-e192-4ff2-bdea-3713eb4b8811",
            "resourceGroupName": "caixa-tests",
            "mlWorkspaceName": "test-ml-studio",
            "servicePrincipalId": "c0a6b74a-26d1-4841-b66a-f449fe5f6296",
            "tenant": "16b3c013-d300-468d-ac64-7eda0820b6d3",
            "encryptedCredential": "ew0KICAiVmVyc2lvbiI6ICIyMDE3LTExLTMwIiwNCiAgIlByb3RlY3Rpb25Nb2RlIjogIktleSIsDQogICJTZWNyZXRDb250ZW50VHlwZSI6ICJQbGFpbnRleHQiLA0KICAiQ3JlZGVudGlhbElkIjogIkRBVEFGQUNUT1JZQDRFRDYyNjI5LUMyREItNDg1Qi05RkRDLTgyRjcxMEFDQzA1RV9hNWU5MjkxNi1mYTA1LTQ1NTctOGRlYS02NzMwMjlhZDRiYTkiDQp9"
        }

## Create Linked Service to the Function App
resource "azurerm_data_factory_linked_service_azure_function" "logic_app_linked_service" {
  name            = "azfunctionlinkedservice"
  data_factory_id       = data.azurerm_data_factory.data-factory.id
  url             = "https://${azurerm_linux_function_app.function_app_cdh.default_hostname}"
  key             = "foo"
}

## Create Linked Service to ML
resource "azurerm_data_factory_linked_custom_service" "aml_linked_service" {
  name                 = "amllinkedservicedls"
  data_factory_id      = data.azurerm_data_factory.data-factory.id
  type                 = "AzureMLService"
  description          = "AzureMLService"
  integration_runtime  {
    name = var.integrated_runtime_name
  }
  type_properties_json = <<JSON
    {
      "subscriptionId": "e685500d-fd78-44fb-838b-07f8fc4c1fcf",
      "resourceGroupName": "cdh-test",
      "mlWorkspaceName": "testmlworkspace",
      "servicePrincipalId": "e685500d-fd78-44fb-838b-07f8fc4c1fcf_JVOFD",
      "tenant": ${data.azurerm_client_config.current.tenant_id},
      "secretAccessKey": {"type": "SecureString", "value": "${var.service_principal_secret}" } 
    }
  JSON
}
