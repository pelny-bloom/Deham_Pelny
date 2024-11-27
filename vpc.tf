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
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-gallery-1"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.2.0/28" 
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-gallery-2"
  }
}