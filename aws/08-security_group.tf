resource "aws_security_group" "es_sg" {
  name   = "${var.common_prefix}-es_sg"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" : "${var.common_prefix}-es_sg"
  }

  ingress {
    description = "Liberacao HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Liberacao HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      "0.0.0.0/0"
    ]
  }
  ingress {
    description = "Liberacao Kibana"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "dns_sg" {
  name   = "${var.common_prefix}-dns_sg"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" : "${var.common_prefix}-dns_sg"
  }

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "udp"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "ssh_sg" {
  name   = "${var.common_prefix}-ssh_sg"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" : "${var.common_prefix}-ssh_sg"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "icpm_sg" {
  name   = "${var.common_prefix}-icpm_sg"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" : "${var.common_prefix}-icpm_sg"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      aws_vpc.main.cidr_block,
      # "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
