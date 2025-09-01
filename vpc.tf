data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "Prd_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "${var.name_prefix}-vpc"
    }
    enable_dns_hostnames = true
    enable_dns_support = true
}
resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.Prd_vpc.id
    cidr_block = var.public_subnet_cidr[count.index]
    map_public_ip_on_launch = true
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
        Tier = "public"
    }

  
}
resource "aws_internet_gateway" "Prd_igw" {
    vpc_id = aws_vpc.Prd_vpc.id
    tags = {
        Name = "${var.name_prefix}-igw"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.Prd_vpc.id
    tags = {
        Name = "${var.name_prefix}-public-rt"
    }
  
}
resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Prd_igw.id
    depends_on = [aws_internet_gateway.Prd_igw]
}
resource "aws_route_table_association" "public_rt_assoc" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.Prd_vpc.id
    cidr_block = var.private_subnet_cidr[count.index]
    map_public_ip_on_launch = false
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
        Tier = "private"
    }
  
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        Name = "${var.name_prefix}-nat-eip"
    }
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet[0].id
    depends_on = [aws_internet_gateway.Prd_igw]
    tags = {
        Name = "${var.name_prefix}-nat-gw"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.Prd_vpc.id
    tags = {
        Name = "${var.name_prefix}-private-rt"
    }
  
}
resource "aws_route" "private_default_route" {
    route_table_id = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
    depends_on = [aws_nat_gateway.nat_gw]
}
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt.id
}