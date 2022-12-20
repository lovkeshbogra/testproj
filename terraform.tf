##################################
# EDIT THE FOLLOWING PARAMETERS
#
# tenant_id :                   Active directory's ID
#                               (Portal) Azure AD -> Properties -> Directory ID
#
# subscription_id:              Subscription ID that you want to onboard
#                               Custom role are going to be created from this subscription
#                               Please use a permanent subscription
#
# cloud_environment:            Cloud environment to be used.
#                               Default: public
#                               Possible values are public, usgovernment, german, and china
#

variable "tenant_id" {
  type = string
  default = "45f038dd-b493-4ce8-965a-e8825d438904"
}
variable "subscription_id" {
  type = string
  default = "f147e8a0-6d15-41c4-8173-9d377a1a7fba"
}
variable "cloud_environment" {
  type = string
  default = "public"
}

# By default setting the password to last for a year
variable "application_password_expiration" {
  type = string
  default = "8760h"
}

# The list of permissions added to the custom role
variable "custom_role_permissions" {
    type = list(string)
    default = [
      "Microsoft.Network/networkInterfaces/effectiveNetworkSecurityGroups/action",
      "Microsoft.Network/networkInterfaces/effectiveRouteTable/action",
      "Microsoft.Network/networkWatchers/securityGroupView/action",
      "Microsoft.Network/networkWatchers/queryFlowLogStatus/action",
      "Microsoft.Network/virtualwans/vpnconfiguration/action",
      "Microsoft.ContainerRegistry/registries/webhooks/getCallbackConfig/action",
      "Microsoft.Web/sites/config/list/action",
      "Microsoft.Web/sites/publishxml/action",
      "Microsoft.Storage/storageAccounts/*", # enable remediation for storage account
      "Microsoft.Compute/virtualMachines/runCommand/action",
      "Microsoft.Web/sites/Write",
      "Microsoft.Web/sites/config/Write",
      "Microsoft.ContainerRegistry/registries/listCredentials/action",
      "Microsoft.DBforMySQL/flexibleServers/configurations/write" # enable remediation for MySQL flexible server
    ]
}
variable "custom_role_compute_agentless_permissions" {
type = list(string)
    default = [
        "Microsoft.Resources/subscriptions/resourceGroups/write",
        "Microsoft.Compute/disks/write",
        "Microsoft.Compute/disks/delete",
        "Microsoft.Compute/disks/beginGetAccess/action",
        "Microsoft.Compute/snapshots/write",
        "Microsoft.Compute/snapshots/delete",
        "Microsoft.Compute/virtualMachines/write",
        "Microsoft.Compute/virtualMachines/delete"
    ]
}


#############################
# Initializing the provider
##############################

terraform {
  required_providers {
    azuread = {
      version = "=1.4.0"
    }
    azurerm = {
      version = "=2.49.0"
    }
    random = {
      version = "=3.1.0"
    }
    time = {
      version = "=0.7.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
  environment = var.cloud_environment
}
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}
provider "random" {}

provider "time" {}

#######################################################
# Setting up an Application & Service Principal
# Will be shared by all of the onboarded subscriptions
#######################################################
resource "random_string" "unique_id" {
  length = 5
  min_lower = 5
  special = false
}

resource "azuread_application" "prisma_cloud_app" {
  display_name               = "Prisma Cloud App ${random_string.unique_id.result}"
  homepage                   = "https://www.paloaltonetworks.com/prisma/cloud"
  available_to_other_tenants = true
}

resource "azuread_service_principal" "prisma_cloud_sp" {
  application_id = azuread_application.prisma_cloud_app.application_id
}

#######################################################
# Generate Application Client Secret
#######################################################
resource "random_password" "application_client_secret" {
  length = 32
  special = true
}

resource "azuread_application_password" "password" {
  value                = random_password.application_client_secret.result
  end_date             = timeadd(timestamp(),var.application_password_expiration)
  application_object_id = azuread_application.prisma_cloud_app.object_id
}


#######################################################
# Setting up custom roles
#######################################################

resource "azurerm_role_definition" "custom_prisma_role" {
  name        = "Prisma Cloud ${random_string.unique_id.result}"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Prisma Cloud custom role created via Terraform"
  assignable_scopes = ["/subscriptions/${var.subscription_id}"]
  permissions {
    actions = distinct(concat(var.custom_role_permissions,var.custom_role_compute_agentless_permissions))
    not_actions = []
  }
  timeouts {
    create = "5m"
    read = "5m"
  }
}

resource "time_sleep" "wait_20_seconds" {
  depends_on = [
    azurerm_role_definition.custom_prisma_role
  ]
  create_duration = "20s"
}

resource "azurerm_role_assignment" "assign_custom_prisma_role" {
  scope       = "/subscriptions/${var.subscription_id}"
  principal_id = azuread_service_principal.prisma_cloud_sp.id
  role_definition_id = azurerm_role_definition.custom_prisma_role.role_definition_resource_id
  depends_on = [
    time_sleep.wait_20_seconds
  ]
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "assign_reader" {
  scope       = "/subscriptions/${var.subscription_id}"
  principal_id = azuread_service_principal.prisma_cloud_sp.id
  role_definition_name = "Reader"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "assign_reader_data_access" {
  scope       = "/subscriptions/${var.subscription_id}"
  principal_id = azuread_service_principal.prisma_cloud_sp.id
  role_definition_name = "Reader and Data Access"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "assign_network_contrib" {
  scope       = "/subscriptions/${var.subscription_id}"
  principal_id = azuread_service_principal.prisma_cloud_sp.id
  role_definition_name = "Network Contributor"
  skip_service_principal_aad_check = true
}


output "a__directory_tenant_id" { value = var.tenant_id}
output "b__subscription_id" { value = var.subscription_id }
output "c__application_client_id" { value = azuread_application.prisma_cloud_app.application_id}
output "d__application_client_secret" { value = nonsensitive(azuread_application_password.password.value)}
output "e__enterprise_application_object_id" { value = azuread_service_principal.prisma_cloud_sp.id}
