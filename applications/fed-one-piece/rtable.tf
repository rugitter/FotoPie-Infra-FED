# Create public route table and route to internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform-public-routetable"
  }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Create private Route Tables 1 and route to nat gateway 1
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_1.id
    }

      tags = {
        Name = "terraform-private-1-routetable"
    }
}

# Associate private route 1 table with private subnet 1
resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

# Create private Route Tables 2 and route to nat gateway 2
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_2.id
  }

    tags = {
      Name = "terraform-private-2-routetable"
   }
}

# Associate private route 2 table with private subnet 2
resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}