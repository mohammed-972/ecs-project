resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecs-vpc"
  }
}

resource "aws_subnet" "sn_public_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "sn_public_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "sn_private_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.101.0/24"

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "sn_private_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.102.0/24"

  tags = {
    Name = "private-2"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ecs-igw"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
    tags = {
      Name = "public-rt"
    }

}



resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.sn_public_1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.sn_public_2.id
  route_table_id = aws_route_table.public-rt.id
}