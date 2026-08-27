# Try to import tag inheritance settings
# 2 conditions must be met to correctly import:
# - var.enable_tag_inheritance is true
# - the settings/taginheritance exist (checked with the data source)
import {
  for_each = (var.enable_tag_inheritance && data.azapi_resource.old_tag_inheritance.exists) ? [1] : []

  identity = {
    id   = "${var.scope_id}/providers/Microsoft.CostManagement/settings/taginheritance"
    type = "Microsoft.CostManagement/settings@2025-03-01"
  }
  to = azapi_resource.tag_inheritance[0]
}
