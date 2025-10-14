resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  region               = var.region
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_a" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = "10.0.3.0/24"
 availability_zone       = "${var.region}a"
 map_public_ip_on_launch = true

 tags = {
   Name = "${var.project_name}-public-a"
   "kubernetes.io/role/elb" = "1"
 }
}

resource "aws_subnet" "public_b" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = "10.0.4.0/24"
 availability_zone       = "${var.region}b"
 map_public_ip_on_launch = true

 tags = {
   Name = "${var.project_name}-public-b"
   "kubernetes.io/role/elb" = "1"
 }
}

resource "aws_subnet" "private_a" {
 vpc_id             = aws_vpc.main.id
 cidr_block         = "10.0.5.0/24"
 availability_zone  = "${var.region}a"

 tags = {
   Name = "${var.project_name}-private-a"
   "kubernetes.io/role/internal-elb" = "1"
 }
}

resource "aws_subnet" "private_b" {
 vpc_id             = aws_vpc.main.id
 cidr_block         = "10.0.6.0/24"
 availability_zone  = "${var.region}b"

 tags = {
   Name = "${var.project_name}-private-b"
   "kubernetes.io/role/internal-elb" = "1"
 }
}

resource "aws_subnet" "db_a" {
 vpc_id             = aws_vpc.main.id
 cidr_block         = "10.0.7.0/24"
 availability_zone  = "${var.region}a"

 tags = {
   Name = "${var.project_name}-db-a"
 }
}

resource "aws_subnet" "db_b" {
 vpc_id             = aws_vpc.main.id
 cidr_block         = "10.0.8.0/24"
 availability_zone  = "${var.region}b"

 tags = {
   Name = "${var.project_name}-db-b"
 }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "${var.project_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-rt-private"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}