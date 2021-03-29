#===== Public =====#
resource "aws_subnet" "public_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.common_prefix}-public-subnet-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "public_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.common_prefix}-public-subnet-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "public_03" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.available.names[2]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.common_prefix}-public-subnet-${data.aws_availability_zones.available.names[2]}"
  }
}

#===== Private =====#
resource "aws_subnet" "nated_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.common_prefix}-nated-subnet-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "nated_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.common_prefix}-nated-subnet-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "nated_03" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 5)
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.common_prefix}-nated-subnet-${data.aws_availability_zones.available.names[2]}"
  }
}
