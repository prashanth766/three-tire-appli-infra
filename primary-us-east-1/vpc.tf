# create the vpc
resource "aws_vpc" "projectvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name="project-vpc"
    }
  
}
# creation of public subnet for frountend loadbalancer
resource "aws_subnet" "pub1" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true  # for auto asign public ip for subnet
    tags = {
      Name="public-1a"
    }
    
  
}
#public subnet for frontend lb
resource "aws_subnet" "pub2" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true  # for auto asign public ip for subnet
    tags = {
      Name="public-1b"
    }
    
  
}
#private subnet for frountend server
resource "aws_subnet" "fpriv1" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name="frntend-private-1a"
    }
    
  
}
#private subnet for frountend server
resource "aws_subnet" "fpriv2" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name="frntend-private-1b"
    }
    
  
}
#private subnet for backend server
resource "aws_subnet" "bpriv1" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name="backend-private-1a"
    }
    
  
}
#private subnet for backend server
resource "aws_subnet" "bpriv2" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name="backend-private-1b"
    }
    
  
}
#rds subnet
resource "aws_subnet" "rdspriv1" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.6.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name="rds-private-1a"
    }
    
  
}
#rds subnet
resource "aws_subnet" "rdspriv2" {
    vpc_id = aws_vpc.projectvpc.id
    cidr_block = "10.0.7.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name="rds-private-1b"
    }
    
  
}
###  CREATION OT INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.projectvpc.id
    tags = {
      Name ="igw"
    }
  
}
#### CREATION PUBLIC ROUTE TABLE AND EDIT ROUTE
resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.projectvpc.id
    tags = {
      Name = "pub-rt"
    }
    route {
        cidr_block="0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}
#### attaching public subne1-1a to public-routtable
resource "aws_route_table_association" "pub1a" {
    route_table_id = aws_route_table.public-rt.id
    subnet_id = aws_subnet.pub1.id
  
}
#### attaching public subne1-1b to public-routtable
resource "aws_route_table_association" "pub1b" {
    route_table_id = aws_route_table.public-rt.id
    subnet_id = aws_subnet.pub2.id
  
}
# CREATION OF ELASTIC-IP FOR NAT
resource "aws_eip" "elastic-ip" {
    
  
}
#CREATION OF NAT
resource "aws_nat_gateway" "nat" {
    subnet_id = aws_subnet.pub1.id
    allocation_id = aws_eip.elastic-ip.id
    connectivity_type = "public"
    tags = {
      Name="NAT"
    }
  
}
##CREATION OF PRIVATE ROUTABLE
resource "aws_route_table" "prvtrt" {
    vpc_id = aws_vpc.projectvpc.id
    tags = {
      Name="prvtrt"
    }
    route {
        gateway_id = aws_nat_gateway.nat.id
        cidr_block = "0.0.0.0/0"
    }
  
}
# attaching fpriv-1a subnet to private route table
resource "aws_route_table_association" "fpriv1" {
    route_table_id = aws_route_table.prvtrt.id
    subnet_id = aws_subnet.fpriv1.id
  
}
# attaching fpriv-1b subnet to private route table
resource "aws_route_table_association" "fpriv2" {
    route_table_id = aws_route_table.prvtrt.id
    subnet_id = aws_subnet.fpriv2.id
  
}
# attaching bpriv-1a subnet to private route table
resource "aws_route_table_association" "bpriv1" {
    route_table_id = aws_route_table.prvtrt.id
    subnet_id = aws_subnet.bpriv1.id
  
}
# attaching bpriv-1b subnet to private route table
resource "aws_route_table_association" "bpriv2" {
    route_table_id = aws_route_table.prvtrt.id
    subnet_id = aws_subnet.bpriv2.id
  
}
# attaching rds-1a subnet to private route table
resource "aws_route_table_association" "rds1" {
    route_table_id = aws_route_table.prvtrt.id
    subnet_id = aws_subnet.rdspriv1.id
  
}
# attaching rds-1b subnet to private route table
resource "aws_route_table_association" "rds2" {
    route_table_id = aws_route_table.prvtrt.id
    subnet_id = aws_subnet.rdspriv2.id
  
}


