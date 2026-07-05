# Scopes
# - billing-account (EA): https://learn.microsoft.com/en-us/azure/templates/microsoft.billing/billingaccounts/policies
# - billing-profile (MCA): https://learn.microsoft.com/en-us/azure/templates/microsoft.billing/billingaccounts/billingprofiles/policies

data "azapi_resource" "old_policies_settings" {
  type = "Microsoft.Billing/billingAccounts/billingProfiles/policies@2024-04-01"
  name = "default"

  parent_id = var.scope_id

  response_export_values = [
    "properties.invoiceSectionLabelManagement",
    "properties.marketplacePurchases",
    "properties.reservationPurchases",
    "properties.savingsPlanPurchases",
    "properties.viewCharges"
  ]
}

locals {
  billing_settings = {
    properties = merge(
      data.azapi_resource.old_policies_settings.output.properties,
      var.enable_cost_management != null ? {
        viewCharges = var.enable_cost_management ? "Allowed" : "NotAllowed"
      } : {},
      var.enable_marketplace != null && var.marketplace_scope != null || !var.enable_marketplace ? {
        marketplacePurchases = var.enable_marketplace ? var.marketplace_scope == "free" ? "OnlyFreeAllowed" : "AllAllowed" : "NotAllowed"
      } : {},
      var.enable_reservation != null ? {
        reservationPurchases = var.enable_reservation ? "Allowed" : "NotAllowed"
      } : {},
      var.enable_saving_plan != null ? {
        savingsPlanPurchases = var.enable_saving_plan ? "Allowed" : "NotAllowed"
      } : {}
    )
  }
}

resource "azapi_update_resource" "new_policies_settings" {
  type = "Microsoft.Billing/billingAccounts/billingProfiles/policies@2024-04-01"
  name = "default"

  parent_id = var.scope_id

  body = local.billing_settings

  response_export_values = [
    "properties.invoiceSectionLabelManagement",
    "properties.marketplacePurchases",
    "properties.reservationPurchases",
    "properties.savingsPlanPurchases",
    "properties.viewCharges"
  ]
}

# Microsoft.CostManagement settings
# Learn more: https://learn.microsoft.com/en-us/azure/templates/microsoft.costmanagement/settings
# resource "azapi_resource" "tag_inheritance" {
#   count = var.enable_tag_inheritance ? 1 : 0

#   type = "Microsoft.CostManagement/Settings@2025-03-01"
#   name = "taginheritance"

#   parent_id = var.scope_id

#   body = {
#     kind = "taginheritance"
#     properties = {
#       preferContainerTags = var.tag_inheritance_scope == "use_inherited_tag"
#     }
#   }

#   response_export_values = [
#     "properties.preferContainerTags",
#   ]
# }
