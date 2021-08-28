provider "aws" {
  region  = "ca-central-1"
}
# Create a VPC
resource "aws_vpc" "rbcvpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    tags = {
        Name = "main"
  }
}
#internet gateway igw.
resource "aws_internet_gateway" "rbcigw" {
  vpc_id = aws_vpc.rbcvpc.id
  tags = {
    Name = "rbcigw"
  }
}
#internet subnet.
resource "aws_subnet" "subnets" {
  count                   = length(var.subnets_cidr)
  vpc_id     = aws_vpc.rbcvpc.id
  cidr_block = element(var.subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "rbc_vpc_subnet_${count.index + 1}"
  }
}
# Route table for demo_vpc
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.rbcvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rbcigw.id
  }
  tags = {
    Name = "rbc_vpc_public_rt"
  }
}

# Route table and subnets assocation
resource "aws_route_table_association" "rt_sub_association" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
