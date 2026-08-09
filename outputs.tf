output "settings" {
  description = <<DESCRIPTION
  Map of updated billing settings.

  - `viewCharges` - Allow Azure subscriptions users to view and optimize costs.
  - `reservationPurchases` - Allow users with access to an Azure subscription to buy Azure Reservations.
  - `savingsPlanPurchases` - Allow users with access to an Azure subscription to buy Azure Saving Plans.
  - `marketplacePurchases` - Allow users with access to an Azure subscription to buy Azure Marketplace products.
  - `invoiceSectionLabelManagement` - Allow users with an owner or a contributor role on an invoice section to manage its tags.
  - `tagInheritance` - Controls tag inheritance.

  ---

  Example:

  ```hcl
  {
    "viewCharges"                   = "NotAllowed"
    "reservationPurchases"          = "NotAllowed"
    "savingsPlanPurchases"          = "NotAllowed"
    "marketplacePurchases"          = "NotAllowed"
    "invoiceSectionLabelManagement" = "Allowed"
    "tagInheritance"                = "preferContainerTags"
  }
  ```

  DESCRIPTION

  value = merge(
    azapi_update_resource.new_policies_settings.output.properties,
    {
      tagInheritance = var.enable_tag_inheritance != null && var.enable_tag_inheritance ? azapi_resource.tag_inheritance[0].output.properties.preferContainerTags ? "use_inherited_tag" : "keep_resource_tag" : try(data.azapi_resource.old_tag_inheritance.output.properties.preferContainerTags, "NotAllowed")
    }
  )
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

  value = local.scope_type
}
