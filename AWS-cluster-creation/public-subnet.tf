/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "k8-igw" {
  vpc_id = aws_vpc.k8-vpc.id
}

/* Public subnet */
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.k8-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.k8-igw]
  tags = {
    Name = "my k8 public subnet"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8-igw.id
  }
  tags = {
    Name = "my k8 public RT"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
