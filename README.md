# Billing Settings Terraform module for Microsoft Azure

Terraform Module to manage billing settings over a billing profile (MCA & MPA), a EA billing account or a MPA Customer.

## Features

Using this module you can manage the following features:

- [Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/get-started-partners#enable-cost-management-for-customer-tenant-subscriptions): Allow Azure subscriptions users to view and optimize costs.
- [Reservation](https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/): Allow users with access to an Azure subscription to buy Azure Reservations.
- [Saving Plan](https://learn.microsoft.com/en-us/azure/cost-management-billing/savings-plan/): Allow users with access to an Azure subscription to buy Azure Saving Plans.
- [Marketplace](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/enable-marketplace-purchases): Allow users with access to an Azure subscription to buy Azure Marketplace products.
- [Invoice Section Label Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/billing-tags#invoice-section-tags): Allow users with an owner or a contributor role on an invoice section to manage its tags. (MCA and MPA with direct billing only)
- [Tag Inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance): Apply billing, resource group, and subscription tags to child resource usage records.

## Compatibility

|      **Feature**     	| **EA billing account** 	| **MCA & MPA billing profile** 	| **MPA Customer** 	|
|:--------------------:	|:----------------------:	|:-----------------------------:	|:----------------:	|
| Cost Management      	|            x           	|               x               	|         x        	|
| Reservation          	|            x           	|               x               	|                  	|
| Saving Plan          	|            x           	|               x               	|                  	|
| Marketplace          	|            x           	|               x               	|                  	|
| Tag Inheritance      	|            x           	|               x               	|                  	|
| Invoice Section Tags 	|                        	|               x               	|                  	|

## Usage

```hcl
module "billing_profile_settings" {
  source  = "alexandre-pares/billing-settings/azure"
  version = "1.0.1"

  scope_id = var.scope_id

  enable_cost_management                = true
  enable_reservation                    = true
  enable_saving_plan                    = true
  enable_marketplace                    = true
  marketplace_scope                     = "free"
  enable_invoice_section_tag_management = true
  enable_tag_inheritance                = true
  tag_inheritance_scope                 = "use_inherited_tag"
}
```

## RBAC Requirements

- Cost Management, Reservation, Saving Plan & Marketplace: [Billing account/profile owner (MCA) or Billing account/profile contributor (MCA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/understand-mca-roles#manage-billing-profile-permissions-properties-and-policies) or [Enterprise Administrator (EA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/understand-ea-roles#enterprise-administrator)
- Tag Inheritance: [Billing profile contributor or Enterprise Administrator (EA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance#required-permissions)


## Remarks

Destroying this module will disable Tag inheritance (if managed by this module).

To enable it back you can go to the Azure Portal > Cost Management > Select your scope > Configuration > Tag inheritance > Check "Automatically apply billing, subscription and resource group tags to new usage data" and configure the tag overwrite setting > Click "Apply"

## Known issues

Tag inheritance cannot be disabled if not managed before.

Fix to disable tag inheritance:

1. Import the tag inheritance resource using the following command:

```bash
# MCA & MPA billing profile
billing_account_id="<replace-me"
billing_profile_id="<replace-me>"
terraform import module.billing_profile_settings.azapi_resource.tag_inheritance[0] /providers/Microsoft.Billing/billingAccounts/$billing_account_id/billingProfiles/$billing_profile_id/providers/Microsoft.CostManagement/Settings/taginheritance?api-version=2025-03-01
```

2. Enable Tag inheritance using `var.enable_tag_inheritance` to `true` and set the approprivate value for `var.tag_inheritance_scope`
3. Disable Tag inheritance using `var.enable_tag_inheritance` to `false` and removing `var.tag_inheritance_scope`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.10 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azapi_resource.tag_inheritance](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_update_resource.new_policies_settings](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/update_resource) | resource |
| [azapi_resource.old_policies_settings](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) | data source |
| [azapi_resource.old_tag_inheritance](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_cost_management"></a> [enable\_cost\_management](#input\_enable\_cost\_management) | Allow Azure subscriptions users to view and optimize costs.<br/><br/>  Examples:<br/>  - `true`  - Enable cost management<br/>  - `false` - Disable cost management (why do that?) | `bool` | `null` | no |
| <a name="input_enable_invoice_section_tag_management"></a> [enable\_invoice\_section\_tag\_management](#input\_enable\_invoice\_section\_tag\_management) | Allow users with an owner or a contributor role on an invoice section to manage its tags.<br/><br/>  Learn more: https://learn.microsoft.com/sr-cyrl-rs/azure/cost-management-billing/costs/billing-tags#invoice-section-tags<br/><br/>  Examples:<br/>  - `true`  - Enable invoice section tag management<br/>  - `false` - Disable invoice section tag management | `bool` | `null` | no |
| <a name="input_enable_marketplace"></a> [enable\_marketplace](#input\_enable\_marketplace) | Allow users with access to an Azure subscription to buy Azure Marketplace products.<br/><br/>  If enabled, you need to specify `var.marketplace_scope`.<br/><br/>  Examples:<br/>  - `true`  - Enable Marketplace products purchases<br/>  - `false` - Disable Marketplace products purchases | `bool` | `null` | no |
| <a name="input_enable_reservation"></a> [enable\_reservation](#input\_enable\_reservation) | Allow users with access to an Azure subscription to buy Azure Reservations.<br/><br/>  Examples:<br/>  - `true`  - Enable reservations purchases<br/>  - `false` - Disable reservations purchases | `bool` | `null` | no |
| <a name="input_enable_saving_plan"></a> [enable\_saving\_plan](#input\_enable\_saving\_plan) | Allow users with access to an Azure subscription to buy Azure Saving Plans.<br/><br/>  Examples:<br/>  - `true`  - Enable Saving Plans purchases<br/>  - `false` - Disable Saving Plans purchases | `bool` | `null` | no |
| <a name="input_enable_tag_inheritance"></a> [enable\_tag\_inheritance](#input\_enable\_tag\_inheritance) | Use tag inheritance to group resource costs and automatically apply billing, subscription and resource group tags to new usage data.<br/><br/>  If enabled, you need to specify `var.tag_inheritance_scope`.<br/><br/>  Examples:<br/>  - `true`  - Enable tag inheritance<br/>  - `false` - Disable tag inheritance | `bool` | `null` | no |
| <a name="input_marketplace_scope"></a> [marketplace\_scope](#input\_marketplace\_scope) | Scope of products that users can access to.<br/><br/>  If set, you must enable marketplace purchases using `var.enable_marketplace`.<br/><br/>  Examples:<br/>  - `free`          - Allow purchases of only Free products<br/>  - `free_and_paid` - Allow purchases of free and paid products | `string` | `null` | no |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Id of the billing scope.<br/><br/>  Can be a billing account (EA only), billing profile (MCA/MPA) or a MPA customer<br/><br/>  Examples:<br/><br/>  - `/providers/Microsoft.Billing/billingAccounts/000000`- Enterprise Agreement (EA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31` - Microsoft Customer Agreement (MCA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30` - Microsoft Partner Agreement (MPA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/billingProfiles/00000000-0000-4000-0000-000000000000` - MPA Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000` - CSP Customer (attached to a MPA) | `string` | n/a | yes |
| <a name="input_tag_inheritance_scope"></a> [tag\_inheritance\_scope](#input\_tag\_inheritance\_scope) | Describe the mecanism when a resource tag has the same key has an inherited tag.<br/><br/>  If set, you must enable tag inheritance using `var.enable_marketplace`.<br/><br/>  Examples:<br/>  - `keep_resource_tag` - Use resource tag instead of inherited tag<br/>  - `use_inherited_tag` - Apply subscription or resource group tag | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_scope_type"></a> [scope\_type](#output\_scope\_type) | Type of the scope where the billing settings are applied.<br/><br/>  These values are only extrapolated from the `scope_id` variable.<br/><br/>  Possible values are:<br/>  - `ea` - Enterprise Agreement (EA) billing account<br/>  - `billing_profile` - MCA and MPA billing profile<br/>  - `mpa_customer` - MPA customer |
| <a name="output_settings"></a> [settings](#output\_settings) | Map of updated billing settings.<br/><br/>  - `viewCharges` - Allow Azure subscriptions users to view and optimize costs.<br/>  - `reservationPurchases` - Allow users with access to an Azure subscription to buy Azure Reservations.<br/>  - `savingsPlanPurchases` - Allow users with access to an Azure subscription to buy Azure Saving Plans.<br/>  - `marketplacePurchases` - Allow users with access to an Azure subscription to buy Azure Marketplace products.<br/>  - `invoiceSectionLabelManagement` - Allow users with an owner or a contributor role on an invoice section to manage its tags.<br/>  - `tagInheritance` - Controls tag inheritance.<br/><br/>  ---<br/><br/>  Example:<pre>hcl<br/>  {<br/>    "viewCharges"                   = "NotAllowed"<br/>    "reservationPurchases"          = "NotAllowed"<br/>    "savingsPlanPurchases"          = "NotAllowed"<br/>    "marketplacePurchases"          = "NotAllowed"<br/>    "invoiceSectionLabelManagement" = "Allowed"<br/>    "tagInheritance"                = "preferContainerTags"<br/>  }</pre> |
<!-- END_TF_DOCS -->
