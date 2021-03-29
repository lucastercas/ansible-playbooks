resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.common_prefix}-igw"
  }
}
