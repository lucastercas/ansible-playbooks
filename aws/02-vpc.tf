resource "aws_vpc" "main" {
  cidr_block       = "10.251.0.0/16"
  instance_tenancy = "default"

  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.common_prefix}-vpc"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name = "key_hyperion"
  public_key = file("~/.ssh/id_rsa.pub")
}