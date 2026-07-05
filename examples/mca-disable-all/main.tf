module "billing_profile_settings" {
  source = "../.."

  scope_id = var.scope_id

  enable_cost_management = false
  enable_marketplace     = false
  enable_reservation     = false
  enable_saving_plan     = false
  # enable_tag_inheritance = false
}
