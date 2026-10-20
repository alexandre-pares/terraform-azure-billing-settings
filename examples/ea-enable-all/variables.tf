variable "scope_id" {
  description = <<DESCRIPTION
  Id of the billing scope. For this example we use a MCA billing profile.

  Examples:

  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile

  DESCRIPTION

  type     = string
  nullable = false
}
