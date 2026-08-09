locals {
  is_ea              = !local.is_billing_profile && !local.is_mpa_customer
  is_billing_profile = strcontains(var.scope_id, "/billingProfiles/") && !local.is_mpa_customer
  is_mpa_customer    = strcontains(var.scope_id, "/customers/")

  scope_type = local.is_ea ? "ea" : local.is_billing_profile ? "billing_profile" : local.is_mpa_customer ? "mpa_customer" : null

  policy_endpoint_by_scope_type = {
    ea              = "Microsoft.Billing/billingAccounts/policies@2024-04-01"
    billing_profile = "Microsoft.Billing/billingAccounts/billingProfiles/policies@2024-04-01"
    mpa_customer    = "Microsoft.Billing/billingAccounts/customers/policies@2024-04-01"
  }

  common_properties = {
    ea_and_billing_profile = merge(
      var.enable_marketplace != null && var.marketplace_scope != null && var.enable_marketplace ? {
        marketplacePurchases = var.enable_marketplace ? var.marketplace_scope == "free" ? "OnlyFreeAllowed" : "AllAllowed" : "NotAllowed"
      } : {},
      var.enable_reservation != null ? {
        reservationPurchases = var.enable_reservation ? "Allowed" : "NotAllowed"
      } : {},
      var.enable_saving_plan != null ? {
        savingsPlanPurchases = var.enable_saving_plan ? "Allowed" : "NotAllowed"
      } : {}
    )

    billing_profile_and_mpa_customer = merge(
      var.enable_cost_management != null ? {
        viewCharges = var.enable_cost_management ? "Allowed" : "NotAllowed"
      } : {}
    )
  }

  properties_by_scope_type = {
    # EA billing account supports:
    # - enable_cost_management using enrollment policies (accountOwnerViewCharges and departmentAdminViewCHarges)
    # - enable_marketplace using marketplacePurchases
    # - enable_reservation using reservationPurchases
    # - enable_saving_plan using savingsPlanPurchases
    #
    # Learn more: https://learn.microsoft.com/en-us/azure/templates/microsoft.billing/billingaccounts/policies
    ea = merge(
      var.enable_cost_management != null ? {
        enrollmentPolicies = {
          accountOwnerViewCharges    = var.enable_cost_management ? "Allowed" : "NotAllowed"
          departmentAdminViewCHarges = var.enable_cost_management ? "Allowed" : "NotAllowed"
        }
      } : {},
      local.common_properties.ea_and_billing_profile
    )

    # MCA and MPA billing profiles supports:
    # - enable_cost_management using viewCharges
    # - enable_marketplace using marketplacePurchases
    # - enable_reservation using reservationPurchases
    # - enable_saving_plan using savingsPlanPurchases
    # - enable_invoice_section_tag_management using invoiceSectionLabelManagement
    #
    # Learn more: https://learn.microsoft.com/en-us/azure/templates/microsoft.billing/billingaccounts/billingprofiles/policies
    billing_profile = merge(
      local.common_properties.billing_profile_and_mpa_customer,
      local.common_properties.ea_and_billing_profile,
      (var.enable_invoice_section_tag_management != null) ? {
        invoiceSectionLabelManagement = var.enable_invoice_section_tag_management ? "Allowed" : "NotAllowed"
      } : {}
    )

    # MPA customer supports:
    # - enable_cost_management using viewCharges
    #
    # MPA customer does not support:
    # - enable_marketplace
    # - enable_reservation
    # - enable_saving_plan
    #
    # Learn more: https://learn.microsoft.com/en-us/azure/templates/microsoft.billing/billingaccounts/customers/policies
    mpa_customer = local.common_properties.billing_profile_and_mpa_customer
  }
}
