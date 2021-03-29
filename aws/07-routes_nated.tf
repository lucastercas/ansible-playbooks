#===== Route Table Nated =====#
resource "aws_route_table" "nated_01" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_01.id
  }
  tags = {
    Name = "${var.common_prefix}-nated-rt-01"
  }
}

resource "aws_route_table" "nated_02" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_02.id
  }
  tags = {
    Name = "${var.common_prefix}-nated-rt-02"
  }
}

resource "aws_route_table" "nated_03" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_03.id
  }
  tags = {
    Name = "${var.common_prefix}-nated-rt-03"
  }
}

#===== Table Association Nated =====#
resource "aws_route_table_association" "nated_01" {
  subnet_id      = aws_subnet.nated_01.id
  route_table_id = aws_route_table.nated_01.id
}

resource "aws_route_table_association" "nated_02" {
  subnet_id      = aws_subnet.nated_02.id
  route_table_id = aws_route_table.nated_02.id
}
