terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    key     = "o1-testnet-alerts.tfstate"
    encrypt = true
    region  = "us-west-2"
    bucket  = "o1labs-terraform-state"
    acl     = "bucket-owner-full-control"
  }
}

variable "download_cortextool" {
  type        = bool
  description = "Whether to automatically download cortextool for linting/testing operations"
  default     = false
}

module "o1testnet_alerts" {
  source = "../modules/testnet-alerts"

  rule_filter            = "{testnet=~\".+\"}" # any non-empty testnet name
  rule_timeframe         = "1h"
  pagerduty_alert_filter = "devnet"

  download_cortextool = var.download_cortextool
}

output "testnet_alert_rules" {
  value = module.o1testnet_alerts.rendered_alerts_config
}

output "testnet_alert_receivers" {
  value     = module.o1testnet_alerts.rendered_receivers_config
  sensitive = true
}
