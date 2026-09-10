variable "resource_group_name" {
  type    = string
  default = "rg-hubspoke-prod"
}

variable "location" {
  type    = string
  default = "DenmarkEast"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}