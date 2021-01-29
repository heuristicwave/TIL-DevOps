// Create Route Table
resource "aws_route_table" "route_table_pub" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_pub"
  }
}

// Associate Route Table
resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.route_table_pub.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.route_table_pub.id
}

// Nat Gateway를 만들기 위한 EIP 발급
resource "aws_eip" "nat_1" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat_2" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

// Allocate EIP & Associate Nat Gateway
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.pub_sub_1.id

  tags = {
    Name = "NAT_GW_1"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.pub_sub_2.id

  tags = {
    Name = "NAT_GW_2"
  }
}
