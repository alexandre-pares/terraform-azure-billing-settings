# Billing Settings Terraform module for Microsoft Azure

Terraform Module to manage billing settings over a billing profile (MCA).

## Features

Using this module you can manage the following features:

- Cost Management: Allow Azure subscriptions users to view and optimize costs.
- [Reservation](https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/): Allow users with access to an Azure subscription to buy Azure Reservations.
- [Saving Plan](https://learn.microsoft.com/en-us/azure/cost-management-billing/savings-plan/): Allow users with access to an Azure subscription to buy Azure Saving Plans.
- [Marketplace](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/enable-marketplace-purchases): Allow users with access to an Azure subscription to buy Azure Marketplace products.

## Usage

```hcl
module "billing_profile_settings" {
  source  = "alexandre-pares/billing-settings/azure"
  version = "1.0.0"

  scope_id = var.scope_id

  enable_cost_management  = true
  enable_reservation      = true
  enable_saving_plan      = true
  enable_marketplace      = true
  marketplace_scope       = "free"
}
```

## RBAC Requirements

- Cost Management, Reservation, Saving Plan & Marketplace: [Billing account/profile owner (MCA) or Billing account/profile contributor (MCA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/understand-mca-roles#manage-billing-profile-permissions-properties-and-policies) or Enterprise Administrator (EA)

## Common errors


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
| [azapi_update_resource.new_policies_settings](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/update_resource) | resource |
| [azapi_resource.old_policies_settings](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_cost_management"></a> [enable\_cost\_management](#input\_enable\_cost\_management) | Allow Azure subscriptions users to view and optimize costs.<br/><br/>  Examples:<br/>  - `true`  - Enable cost management<br/>  - `false` - Disable cost management (why do that?) | `bool` | `null` | no |
| <a name="input_enable_marketplace"></a> [enable\_marketplace](#input\_enable\_marketplace) | Allow users with access to an Azure subscription to buy Azure Marketplace products.<br/><br/>  If enabled, you need to specify `var.marketplace_scope`.<br/><br/>  Examples:<br/>  - `true`  - Enable Marketplace products purchases<br/>  - `false` - Disable Marketplace products purchases | `bool` | `null` | no |
| <a name="input_enable_reservation"></a> [enable\_reservation](#input\_enable\_reservation) | Allow users with access to an Azure subscription to buy Azure Reservations.<br/><br/>  Examples:<br/>  - `true`  - Enable reservations purchases<br/>  - `false` - Disable reservations purchases | `bool` | `null` | no |
| <a name="input_enable_saving_plan"></a> [enable\_saving\_plan](#input\_enable\_saving\_plan) | Allow users with access to an Azure subscription to buy Azure Saving Plans.<br/><br/>  Examples:<br/>  - `true`  - Enable Saving Plans purchases<br/>  - `false` - Disable Saving Plans purchases | `bool` | `null` | no |
| <a name="input_marketplace_scope"></a> [marketplace\_scope](#input\_marketplace\_scope) | Scope of products that users can access to.<br/><br/>  If set, you must enable marketplace purchases using `var.enable_marketplace`.<br/><br/>  Examples:<br/>  - `free`          - Allow purchases of only Free products<br/>  - `free_and_paid` - Allow purchases of free and paid products | `string` | `null` | no |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Id of the billing scope.<br/><br/>  Can be a billing account (EA only), billing profile, enrollment account, invoice section, CSP customer, etc.<br/><br/>  Examples:<br/><br/>  - `/providers/Microsoft.Billing/billingAccounts/000000`- Enterprise Agreement (EA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31` - Microsoft Customer Agreement (MCA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30` - Microsoft Partner Agreement (MPA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/billingProfiles/00000000-0000-4000-0000-000000000000` - MPA Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000` - MCA Invoice section<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/00000000-0000-4000-0000-000000000000` - MCA Invoice section<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000` - CSP Customer (attached to a MPA) | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_settings"></a> [settings](#output\_settings) | Map of updated billing settings.<br/><br/>  - `viewCharges` - Allow Azure subscriptions users to view and optimize costs.<br/>  - `reservationPurchases` - Allow users with access to an Azure subscription to buy Azure Reservations.<br/>  - `savingsPlanPurchases` - Allow users with access to an Azure subscription to buy Azure Saving Plans.<br/>  - `marketplacePurchases` - Allow users with access to an Azure subscription to buy Azure Marketplace products.<br/>  - `invoiceSectionLabelManagement` - Controls invoice section label management at invoice section scope.<br/><br/>  ---<br/><br/>  Example:<pre>hcl<br/>  {<br/>    "viewCharges"                   = "NotAllowed"<br/>    "reservationPurchases"          = "NotAllowed"<br/>    "savingsPlanPurchases"          = "NotAllowed"<br/>    "marketplacePurchases"          = "NotAllowed"<br/>    "invoiceSectionLabelManagement" = "Allowed"<br/>  }</pre> |
<!-- END_TF_DOCS -->
