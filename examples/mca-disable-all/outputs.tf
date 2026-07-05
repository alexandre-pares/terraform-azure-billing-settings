output "settings" {
  description = <<DESCRIPTION
  Map of updated billing settings.

  - `viewCharges` - Allow Azure subscriptions users to view and optimize costs.
  - `reservationPurchases` - Allow users with access to an Azure subscription to buy Azure Reservations.
  - `savingsPlanPurchases` - Allow users with access to an Azure subscription to buy Azure Saving Plans.
  - `marketplacePurchases` - Allow users with access to an Azure subscription to buy Azure Marketplace products.
  - `invoiceSectionLabelManagement` - Controls invoice section label management at invoice section scope.

  ---

  Example:

  ```hcl
  {
    "viewCharges"                   = "NotAllowed"
    "reservationPurchases"          = "NotAllowed"
    "savingsPlanPurchases"          = "NotAllowed"
    "marketplacePurchases"          = "NotAllowed"
    "invoiceSectionLabelManagement" = "Allowed"
  }
  ```

  DESCRIPTION

  value = module.billing_profile_settings.settings
}
