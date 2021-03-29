resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.251.0.0/16"
  instance_tenancy = "default"

  enable_dns_support               = true
  enable_dns_hostname              = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.common_prefix}-vpc"
  }
}
