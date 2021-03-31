# resource "aws_eip" "nat_gw_eip_01" {
#   vpc = true
# }

# resource "aws_eip" "nat_gw_eip_02" {
#   vpc = true
# }

# resource "aws_eip" "nat_gw_eip_03" {
#   vpc = true
# }

# resource "aws_nat_gateway" "gw_01" {
#   allocation_id = aws_eip.nat_gw_eip_01.id
#   subnet_id     = aws_subnet.public_01.id
# }

# resource "aws_nat_gateway" "gw_02" {
#   allocation_id = aws_eip.nat_gw_eip_02.id
#   subnet_id     = aws_subnet.public_02.id
# }

# resource "aws_nat_gateway" "gw_03" {
#   allocation_id = aws_eip.nat_gw_eip_03.id
#   subnet_id     = aws_subnet.public_03.id
# }