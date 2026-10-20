variable "scope_id" {
  description = <<DESCRIPTION
  Id of the billing scope.

  Can be a billing account (EA only), billing profile (MCA/MPA) or a MPA customer.

  Examples:

  - `/providers/Microsoft.Billing/billingAccounts/000000`- Enterprise Agreement (EA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31` - Microsoft Customer Agreement (MCA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30` - Microsoft Partner Agreement (MPA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/billingProfiles/00000000-0000-4000-0000-000000000000` - MPA Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000` - CSP Customer (attached to a MPA)

  DESCRIPTION

  type     = string
  nullable = false
}

variable "enable_cost_management" {
  description = <<DESCRIPTION
  Allow Azure subscriptions users to view and optimize costs.

  For EA biling account, this will enable/disable `accountOwnerViewCharges` and `departmentAdminViewCharges` settings.

  Examples:
  - `true`  - Enable cost management
  - `false` - Disable cost management (why do that?)

  DESCRIPTION

  type     = bool
  nullable = true
  default  = null
}

variable "enable_reservation" {
  description = <<DESCRIPTION
  Allow users with access to an Azure subscription to buy Azure Reservations.

  Examples:
  - `true`  - Enable reservations purchases
  - `false` - Disable reservations purchases

  DESCRIPTION

  type     = bool
  nullable = true
  default  = null
}

variable "enable_saving_plan" {
  description = <<DESCRIPTION
  Allow users with access to an Azure subscription to buy Azure Saving Plans.

  Examples:
  - `true`  - Enable Saving Plans purchases
  - `false` - Disable Saving Plans purchases

  DESCRIPTION

  type     = bool
  nullable = true
  default  = null
}

variable "enable_marketplace" {
  description = <<DESCRIPTION
  Allow users with access to an Azure subscription to buy Azure Marketplace products.

  If enabled, you need to specify `var.marketplace_scope`.

  If you are using the Private Azure Marketplace, then you can disable the marketplace.

  Examples:
  - `true`  - Enable Marketplace products purchases
  - `false` - Disable Marketplace products purchases

  DESCRIPTION

  type     = bool
  nullable = true
  default  = null
}

variable "marketplace_scope" {
  description = <<DESCRIPTION
  Scope of products that users can access to.

  If set, you must enable marketplace purchases using `var.enable_marketplace`.

  Examples:
  - `free`          - Allow purchases of only Free products
  - `free_and_paid` - Allow purchases of free and paid products

  DESCRIPTION

  validation {
    condition     = var.enable_marketplace == true ? contains(["free", "free_and_paid"], var.marketplace_scope) : true
    error_message = "'marketplace_scope' must be set when 'enable_marketplace' is set to 'true'"
  }

  type     = string
  nullable = true
  default  = null
}

variable "enable_invoice_section_tag_management" {
  description = <<DESCRIPTION
  Allow users with an owner or a contributor role on an invoice section to manage its tags.

  This feature is only available on MCA/MPA billing profiles.

  Learn more: https://learn.microsoft.com/sr-cyrl-rs/azure/cost-management-billing/costs/billing-tags#invoice-section-tags

  Examples:
  - `true`  - Enable invoice section tag management
  - `false` - Disable invoice section tag management

  DESCRIPTION

  type     = bool
  nullable = true
  default  = null
}

variable "enable_tag_inheritance" {
  description = <<DESCRIPTION
  Use tag inheritance to group resource costs and automatically apply billing, subscription and resource group tags to new usage data.

  If enabled, you need to specify `var.tag_inheritance_scope`.

  Examples:
  - `true`  - Enable tag inheritance
  - `false` - Disable tag inheritance

  DESCRIPTION

  type     = bool
  nullable = true
  default  = null
}

variable "tag_inheritance_scope" {
  description = <<DESCRIPTION
  Describe the mecanism when a resource tag has the same key has an inherited tag.

  If set, you must enable tag inheritance using `var.enable_marketplace`.

  Examples:
  - `keep_resource_tag` - Use resource tag instead of inherited tag
  - `use_inherited_tag` - Apply subscription or resource group tag

  DESCRIPTION

  type     = string
  nullable = true
  default  = null
}

variable "resource_types" {
  description = <<DESCRIPTION
  Override the AzAPI `<provider>/<resource>@<api-version>` strings used by this module. Each key defaults to a tested value; supply only the keys you want to override. Useful when targeting a sovereign cloud with older API versions, or when opting into a newer preview API.

  - `ea_billing_account`  - The billing account settings - only if var.scope_id is a EA billing account.
  - `billing_profile`     - The billing profile policies - only if var.scope_id is a MCA or MPA billing profile.
  - `mpa_customer`        - The customer policies - only if var.scope_id is a MPA customer.
  - `tag_inheritance`     - The cost management settings used to managed tag inheritance.

  DESCRIPTION

  type = object({
    ea_billing_account = optional(string, "Microsoft.Billing/billingAccounts/policies@2024-04-01")
    billing_profile    = optional(string, "Microsoft.Billing/billingAccounts/billingProfiles/policies@2024-04-01")
    mpa_customer       = optional(string, "Microsoft.Billing/billingAccounts/customers/policies@2024-04-01")
    tag_inheritance    = optional(string, "Microsoft.CostManagement/settings@2025-03-01")
  })
  nullable = false
  default  = {}
}
