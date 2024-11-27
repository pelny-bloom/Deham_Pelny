# Create a VPC to launch our instances into
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/24"  
  enable_dns_hostnames = true 
  enable_dns_support = true
  
  tags       =  {
    Name     = "gallery vpc"
  }       
}
