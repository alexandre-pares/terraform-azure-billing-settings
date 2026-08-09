data "azapi_resource" "old_policies_settings" {
  type = local.policy_endpoint_by_scope_type[local.scope_type]
  name = "default"

  parent_id = var.scope_id

  response_export_values = ["*"]
}

resource "azapi_update_resource" "new_policies_settings" {
  type = local.policy_endpoint_by_scope_type[local.scope_type]
  name = "default"

  parent_id = var.scope_id

  body = {
    properties = merge(
      data.azapi_resource.old_policies_settings.output.properties,
      local.properties_by_scope_type[local.scope_type],
    )
  }

  response_export_values = ["*"]
}

# Microsoft.CostManagement settings
# Learn more: https://learn.microsoft.com/en-us/azure/templates/microsoft.costmanagement/settings
data "azapi_resource" "old_tag_inheritance" {
  type = "Microsoft.CostManagement/Settings@2025-03-01"
  name = "taginheritance"

  parent_id = var.scope_id

  response_export_values = [
    "properties.preferContainerTags",
  ]

  # Required because when tag inheritance is disabled, the resource does not exist and will return a 404 not found error
  ignore_not_found = true
}

resource "azapi_resource" "tag_inheritance" {
  count = var.enable_tag_inheritance != null && var.enable_tag_inheritance ? 1 : 0

  type = "Microsoft.CostManagement/Settings@2025-03-01"
  name = "taginheritance"

  parent_id = var.scope_id

  body = {
    kind = "taginheritance"
    properties = {
      preferContainerTags = var.tag_inheritance_scope == "use_inherited_tag"
    }
  }

  response_export_values = [
    "properties.preferContainerTags",
  ]
}
