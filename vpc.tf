resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name : "Development_VPC"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

#Create Clixx Web-App Subnets in 2 AZ
resource "aws_subnet" "web-private-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.1.12.0/25"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ECS-Private-Subnet-1a"
  }
}

resource "aws_subnet" "web-private-subnet-2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.1.12.128/25"
  availability_zone = "us-east-1b"

  tags = {
    Name = "ECS-Private-Subnet-1b"
  }
}

#Create LB & NAT Subnet 
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.1.8.0/23"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public-Subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.1.10.0/23"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public-Subnet-1b"
  }
}

#Create database Private Subnet 
resource "aws_subnet" "db-private-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.1.0.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database-Private-Subnet-1a"
  }
}

resource "aws_subnet" "db-private-subnet-2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.1.4.0/22"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database-Private-Subnet-1b"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "ECS_IGW"
  }
}

#Nat Gateway for ECS Private Subnets
resource "aws_eip" "ip" {
  vpc = true
}

resource "aws_eip" "ip2" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "Stack_NATGW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.dev-gw]
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.ip2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name = "Stack_NATGW_2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.dev-gw]
}

#ECS webapp route table
resource "aws_route_table" "webapp" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table" "webapp2" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw2.id
  }

  tags = {
    Name = "Private-Route-Table-2"
  }
}

#public subnet route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

# ECS webapp subnet and route table association 
resource "aws_route_table_association" "webapp-private-1" {
  subnet_id      = aws_subnet.web-private-subnet-1.id
  route_table_id = aws_route_table.webapp.id

}

resource "aws_route_table_association" "webapp-private-2" {
  subnet_id      = aws_subnet.web-private-subnet-2.id
  route_table_id = aws_route_table.webapp2.id

}

#Public Subnet and route table association
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public.id
}