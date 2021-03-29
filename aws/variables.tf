variable "region" {
  type    = string
  default = "us-east-1"
}

variable "common_prefix" {
  type    = string
  default = "demo"
}

variable "elk_domain" {
  type    = string
  default = "demo-elk-domain"
}


data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
