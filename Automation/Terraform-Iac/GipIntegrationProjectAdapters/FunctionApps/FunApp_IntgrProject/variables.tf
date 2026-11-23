# ---- Passed by the workflow as TF_VAR_* environment variables ----
variable "INTEGRATION_NAME" {
  description = "Integration name, used in resource names"
  type        = string
}

variable "GITHUB_PAT_TOKEN" {
  description = "GitHub token (unused for now, declared because the workflow sets it)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "GITHUB_BRANCH_NAME" {
  description = "Branch that triggered the run (unused for now, used for tagging)"
  type        = string
  default     = ""
}

# ---- Supplied by environments/<region>/<env>.tfvars ----
variable "ENVIRONMENT" {
  description = "dev, qa, uat or prd"
  type        = string
}

variable "REGION" {
  description = "Short region code: uks or aue"
  type        = string
}

variable "LOCATION" {
  description = "Azure region name, e.g. uksouth or australiaeast"
  type        = string
}

variable "FUNCTION_PLAN_SKU" {
  description = "App Service plan SKU. Y1 = Consumption (cheapest, free-trial friendly)"
  type        = string
  default     = "Y1"
}

# Read by the workflow with grep to find the state storage account.
# Declared here so Terraform does not warn about undeclared variables.
variable "RESOURCE_GROUP_NAME" {
  description = "Resource group that holds the Terraform state storage account"
  type        = string
}

variable "STATE_FILE_SA_NAME" {
  description = "Storage account that holds the Terraform state"
  type        = string
}

