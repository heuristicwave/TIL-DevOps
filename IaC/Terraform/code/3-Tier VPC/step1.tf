/*
    각 계정 혹은 리전 마다 할당된 az가 다르기 때문에,
    사용가능한 az를 체크해 data에 저장해 활용합니다.
*/

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "3-Tier"
  }
}

# Create Subnet
resource "aws_subnet" "pub_sub_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public_subnet_2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "3-Tier"
  }
}
