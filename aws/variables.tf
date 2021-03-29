variable "region" {
  type    = string
  default = "us-east-1"
}

variable "common_prefix" {
  type = string
  default = "demo"
}

locals {
  common_prefix = "demo"
  elk_domain    = "${local.common_prefix}-elk-domain"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
