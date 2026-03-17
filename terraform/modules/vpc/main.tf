resource "aws_vpc" "tm_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "tm_public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "tm_igw" {
  vpc_id = aws_vpc.tm_vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "tm_public_rt" {
  vpc_id = aws_vpc.tm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tm_igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "tm_subnet_rt_assoc" {
  count          = length(aws_subnet.tm_public_subnet)
  subnet_id      = aws_subnet.tm_public_subnet[count.index].id
  route_table_id = aws_route_table.tm_public_rt.id
}


resource "aws_subnet" "tm_private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

# Add to vpc/main.tf

resource "aws_eip" "tm_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "tm_nat" {
  allocation_id = aws_eip.tm_nat_eip.id
  subnet_id     = aws_subnet.tm_public_subnet[0].id # NAT lives in public subnet

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

resource "aws_route_table" "tm_private_rt" {
  vpc_id = aws_vpc.tm_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tm_nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "tm_private_rt_assoc" {
  count          = length(aws_subnet.tm_private_subnet)
  subnet_id      = aws_subnet.tm_private_subnet[count.index].id
  route_table_id = aws_route_table.tm_private_rt.id
}