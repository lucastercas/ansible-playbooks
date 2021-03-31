resource "aws_instance" "dns" {
  count         = 1
  instance_type = "t2.micro"
  ami           = "ami-09d246ada0ae2e13c"
  key_name      = "key_hyperion"

  vpc_security_group_ids = [
    aws_security_group.ssh_sg.id,
    aws_security_group.dns_sg.id,
    aws_security_group.icpm_sg.id,
  ]

  subnet_id = aws_subnet.public_01.id

  tags = {
    "Name" = "dns-${count.index}"
  }
}

resource "aws_instance" "loadbalancer" {
  count         = 1
  instance_type = "t2.micro"
  ami           = "ami-09d246ada0ae2e13c"
  key_name      = "key_hyperion"

  vpc_security_group_ids = [
    aws_security_group.ssh_sg.id,
    aws_security_group.icpm_sg.id,
  ]

  subnet_id = aws_subnet.public_01.id

  tags = {
    "Name" = "loadbalancer-${count.index}"
  }
}
