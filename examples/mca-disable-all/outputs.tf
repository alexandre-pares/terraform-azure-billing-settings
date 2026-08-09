output "settings" {
  description = <<DESCRIPTION
  Map of updated billing settings.

  - `viewCharges` - Allow Azure subscriptions users to view and optimize costs.
  - `reservationPurchases` - Allow users with access to an Azure subscription to buy Azure Reservations.
  - `savingsPlanPurchases` - Allow users with access to an Azure subscription to buy Azure Saving Plans.
  - `marketplacePurchases` - Allow users with access to an Azure subscription to buy Azure Marketplace products.
  - `invoiceSectionLabelManagement` - Controls invoice section label management at invoice section scope.
  - `tagInheritance` - Controls tag inheritance.

  ---

  Example:

  ```hcl
  {
    "viewCharges"                   = "NotAllowed"
    "reservationPurchases"          = "NotAllowed"
    "savingsPlanPurchases"          = "NotAllowed"
    "marketplacePurchases"          = "NotAllowed"
    "invoiceSectionLabelManagement" = "NotAllowed"
    "tagInheritance"                = "NotAllowed"
  }
  ```

  DESCRIPTION

  value = module.billing_profile_settings.settings
}

output "scope_type" {
  description = <<DESCRIPTION
  Type of the scope where the billing settings are applied.

  These values are only extrapolated from the `scope_id` variable.

  Possible values are:
  - `ea` - Enterprise Agreement (EA) billing account
  - `billing_profile` - MCA and MPA billing profile
  - `mpa_customer` - MPA customer

  DESCRIPTION

  value = module.billing_profile_settings.scope_type
}
