resource "aws_subnet" "public_01" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
}
