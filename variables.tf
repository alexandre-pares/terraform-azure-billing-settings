variable "scope_id" {
  description = <<DESCRIPTION
  Id of the billing scope.

  Can be a billing account (EA only), billing profile, enrollment account, invoice section, CSP customer, etc.

  Examples:

  - `/providers/Microsoft.Billing/billingAccounts/000000`- Enterprise Agreement (EA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31` - Microsoft Customer Agreement (MCA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30` - Microsoft Partner Agreement (MPA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/billingProfiles/00000000-0000-4000-0000-000000000000` - MPA Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000` - MCA Invoice section
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/00000000-0000-4000-0000-000000000000` - MCA Invoice section
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000` - CSP Customer (attached to a MPA)

  DESCRIPTION

  type     = string
  nullable = false
}

variable "enable_cost_management" {
  description = <<DESCRIPTION
  Allow Azure subscriptions users to view and optimize costs.

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

  type     = string
  nullable = true
  default  = null
}

# variable "enable_private_marketplace" {
#   description = <<DESCRIPTION
#   Allow selected users to find, try, and buy or deploy products selected by their administrators, and take advantage of all benefits of Azure Marketplace.

#   Learn more: https://aka.ms/privateazuremarketplace

#   If set, you must enable marketplace purchases using `var.enable_marketplace`.

#   Examples:
#   - `true`  - Enable private marketplace products purchases
#   - `false` - Disable private marketplace products purchases

#   DESCRIPTION

#   type     = bool
#   nullable = true
#   default  = null
# }

# variable "enable_tag_inheritance" {
#   description = <<DESCRIPTION
#   Use tag inheritance to group resource costs and automatically apply billing, subscription and resource group tags to new usage data.

#   If enabled, you need to specify `var.tag_inheritance_scope`.

#   Examples:
#   - `true`  - Enable tag inheritance
#   - `false` - Disable tag inheritance

#   DESCRIPTION

#   type     = bool
#   nullable = true
#   default  = null
# }

# variable "tag_inheritance_scope" {
#   description = <<DESCRIPTION
#   Describe the mecanism when a resource tag has the same key has an inherited tag.

#   If set, you must enable tag inheritance using `var.enable_marketplace`.

#   Examples:
#   - `keep_resource_tag` - Use resource tag instead of inherited tag
#   - `use_inherited_tag` - Apply subscription or resource group tag

#   DESCRIPTION

#   type     = string
#   nullable = true
#   default  = null
# }
