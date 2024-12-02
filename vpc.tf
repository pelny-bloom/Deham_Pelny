# Create a VPC to launch our instances into
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/24"  
  enable_dns_hostnames = true 
  enable_dns_support = true
  
  tags       =  {
    Name     = "gallery vpc"
  }       
}
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "igw gallery"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.0/26" 
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-gallery-1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.64/26" 
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-gallery-2"
  }
}
# Create Public Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_RT_Gallery"
  }
}

#Create association with public subnet 1
resource "aws_route_table_association" "Public_Subnet1_Asso" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_1.id
  depends_on     = [aws_route_table.public, aws_subnet.public_1]
}

#Create association with public subnet 2
resource "aws_route_table_association" "Public_Subnet2_Asso" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_2.id
  depends_on     = [aws_route_table.public, aws_subnet.public_2]
}

# Create Private Subnet 1
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.128/26" 
  availability_zone       = "us-west-2a"

  tags = {
    Name = "private-gallery-1"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.192/26" 
  availability_zone       = "us-west-2b"

  tags = {
    Name = "private-gallery-2"
  }
}

