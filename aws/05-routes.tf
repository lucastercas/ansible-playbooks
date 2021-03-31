# #===== Route Table Public =====#
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.common_prefix}-public-rt"
  }
}

# #===== Table Associations Public =====#
resource "aws_route_table_association" "public_01" {
  subnet_id      = aws_subnet.public_01.id
  route_table_id = aws_route_table.public.id
}
# resource "aws_route_table_association" "public_02" {
#   subnet_id      = aws_subnet.public_02.id
#   route_table_id = aws_route_table.public.id
# }
# resource "aws_route_table_association" "public_03" {
#   subnet_id      = aws_subnet.public_03.id
#   route_table_id = aws_route_table.public.id
# }
