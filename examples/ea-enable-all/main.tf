module "billing_account_settings" {
  source = "../.."

  scope_id = var.scope_id

  enable_cost_management = true
  enable_reservation     = true
  enable_saving_plan     = true
  enable_marketplace     = true
  marketplace_scope      = "free"
  enable_tag_inheritance = true
  tag_inheritance_scope  = "use_inherited_tag"
}
