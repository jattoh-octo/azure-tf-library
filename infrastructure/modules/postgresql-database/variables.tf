variable "basename" {
  type        = string
  description = "Basename of the module."
  validation {
    condition     = can(regex("^[-0-9a-z]{1,50}$", var.basename)) && can(regex("[0-9a-z]+$", var.basename))
    error_message = "The name must be between 1 and 50 characters, can only contain lowercase letters, numbers, and hyphens. Must not end with a hyphen."
  }
}

variable "rg_name" {
  type        = string
  description = "Resource group name."
  validation {
    condition     = can(regex("^[-\\w\\.\\(\\)]{1,90}$", var.rg_name)) && can(regex("[-\\w\\(\\)]+$", var.rg_name))
    error_message = "Resource group names must be between 1 and 90 characters and can only include alphanumeric, underscore, parentheses, hyphen, period (except at end)."
  }
}

variable "location" {
  type        = string
  description = "Location of the resource group."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the deployed resource."
}

variable "module_enabled" {
  type        = bool
  description = "Variable to enable or disable the module."
  default     = true
}

variable "is_sec_module" {
  type        = bool
  description = "Is secure module?"
  default     = true
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet delegated to PostgreSQL for the service to be injected privately in that subnet"
  default     = ""
}

variable "private_dns_zone_id" {
  type        = string
  description = "Specifies the Private DNS Zone to include"
  default     = ""
}

variable "administrator_login" {
  type        = string
  description = "The Administrator login for the PostgreSQL Server"
  default     = "sqladminuser"
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login"
  default     = "ThisIsNotVerySecure!"
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server"
  default     = "GP_Standard_D4s_v3"
}

variable "storage_mb" {
  type        = number
  description = "Max storage allowed for this PostgreSQL Server"
  validation {
    condition     = contains([2768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216], var.storage_mb)
    error_message = "Valid values for storage_mb are 2768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, or 16777216"
  }
  default = 65536
}

variable "ver" {
  type        = string
  description = "Specifies the version of PostgreSQL to use"
  validation {
    condition     = contains(["11", "12", "13", "14"], var.ver)
    error_message = "Valid values for ver are in the range [11, 14]."
  }
  default = "14"
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the server"
  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "Valid values for backup_retention_days are in the range [7, 35]."
  }
  default = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Turn Geo-redundant server backups on/off."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this server."
  default     = false
}

variable "charset" {
  type        = string
  description = "Specifies the Charset for the PostgreSQL Database."
  default     = "UTF8"
}

variable "collation" {
  type        = string
  description = "Specifies the Collation for the PostgreSQL Database"
  default     = "en_US.utf8"
}

variable "identity_ids" {
  type        = list(string)
  description = "Specifies the IDs of the User Assigned Managed Identities to be assigned to the PostgreSQL Server"
  default     = []
}

variable "customer_managed_key" {
  type = map(
    object(
      {
        key_vault_key_id                  = optional(string)
        primary_user_assigned_identity_id = optional(string)
      }
    )
  )
  description = "Specifies the ID of the User Assigned Managed Identity to be used by PostgreSQL Server to access the Customer Managed Key"
  validation {
    condition     = length(var.customer_managed_key) <= 1
    error_message = "customer_managed_key accepts, at most, one object"
  }
  default = {}
}