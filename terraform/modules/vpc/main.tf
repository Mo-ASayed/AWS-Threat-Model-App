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
