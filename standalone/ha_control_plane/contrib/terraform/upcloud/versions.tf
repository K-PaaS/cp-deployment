
terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "~>2.5.0"
    }
  }
  required_version = ">= 0.13"
}
