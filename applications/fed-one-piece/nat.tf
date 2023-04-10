# Create two Nat gateway and two elestic IP associating with two public subnets

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "terraform-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "terraform-nat-gateway-2"
  }
}

resource "aws_eip" "nat_1" {
  vpc = true

  tags = {
    Name = "terraform-nat-eip-1"
  }
}

resource "aws_eip" "nat_2" {
  vpc = true

  tags = {
    Name = "terraform-nat-eip-2"
  }
}