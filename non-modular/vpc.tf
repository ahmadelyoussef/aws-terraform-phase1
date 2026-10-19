
# =========================
# VPC
# =========================

resource "aws_vpc" "phase1_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-phase1-vpc"
  }
}

# =========================
# PUBLIC SUBNETS
# =========================

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.phase1_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-phase1-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.phase1_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-phase1-public-subnet-2"
  }
}

# =========================
# PRIVATE SUBNETS
# =========================

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.phase1_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-phase1-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.phase1_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-phase1-private-subnet-2"
  }
}

# =========================
# INTERNET GATEWAY
# =========================

resource "aws_internet_gateway" "phase1_igw" {
  vpc_id = aws_vpc.phase1_vpc.id

  tags = {
    Name = "tf-phase1-igw"
  }
}

# =========================
# PUBLIC ROUTE TABLE
# =========================

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.phase1_vpc.id

  tags = {
    Name = "tf-phase1-public-rt"
  }
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.phase1_igw.id
}

resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# =========================
# ELASTIC IP AND NAT GATEWAY
# =========================

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "tf-phase1-nat-eip"
  }
}

resource "aws_nat_gateway" "phase1_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  depends_on = [
    aws_route.public_internet_route,
    aws_route_table_association.public_subnet_1_assoc
  ]

  tags = {
    Name = "tf-phase1-nat-gateway"
  }
}

# =========================
# PRIVATE ROUTE TABLE
# =========================

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.phase1_vpc.id

  tags = {
    Name = "tf-phase1-private-rt"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.phase1_nat.id
}

resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}
