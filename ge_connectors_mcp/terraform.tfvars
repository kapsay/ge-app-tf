# ==============================================================================
# Terraform Variable Values
# ==============================================================================

project_id        = "<Your Project ID>"
project_num       = "<Your Project NUM>"
location          = "global"

# MCP Data Store (ge_dc_mcp)
mcp_data_store_id                = "kroger_demo_ds_mcp"
mcp_data_store_display_name      = "mcp_data"
mcp_data_store_industry_vertical = "GENERIC"
mcp_data_store_solution_types    = ["SOLUTION_TYPE_SEARCH"]
mcp_data_store_acl_enabled       = false
mcp_data_store_deletion_policy   = "DELETE"
mcp_data_store_default_schema_id = "default_schema"