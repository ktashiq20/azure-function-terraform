# Values for dev in UK South.
# Keep each key on its own line with a plain "key = value" format:
# the workflow reads two of them with grep and cut.

ENVIRONMENT = "dev"
REGION      = "uks"
LOCATION    = "uksouth"

# Resource group and storage account created in the bootstrap step (hold the tfstate)
RESOURCE_GROUP_NAME = "rg-tfstate-dev-uks"
STATE_FILE_SA_NAME  = "sttfstatedevuksasq"

# Y1 = Consumption plan
FUNCTION_PLAN_SKU = "Y1"
