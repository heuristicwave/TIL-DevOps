// Create Private Subnet
resource "aws_subnet" "pri_sub_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/22"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "pri_sub_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.8.0/22"

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private_subnet_2"
  }
}

// Create Private Route Table
resource "aws_route_table" "route_table_pri_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_pri_1"
  }
}

resource "aws_route_table" "route_table_pri_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_pri_2"
  }
}

// Associate Route Table
resource "aws_route_table_association" "route_table_pri_association_1" {
  subnet_id      = aws_subnet.pri_sub_1.id
  route_table_id = aws_route_table.route_table_pri_1.id
}

resource "aws_route_table_association" "route_table_pri_association_2" {
  subnet_id      = aws_subnet.pri_sub_2.id
  route_table_id = aws_route_table.route_table_pri_2.id
}

resource "aws_route" "private_nat_1" {
  route_table_id         = aws_route_table.route_table_pri_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route" "private_nat_2" {
  route_table_id         = aws_route_table.route_table_pri_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_2.id
}
