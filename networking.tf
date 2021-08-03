resource "aws_vpc" "terraform" {
  cidr_block       = "${var.cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

##allow eip for vpc
#resource "aws_eip" "eip_manager" {
  #count = 2
 # vpc = true
#}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id


}
# Create Custom Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pubsubnet[0].id
  route_table_id = aws_route_table.prod-route-table.id
}

## Public subnet
resource "aws_subnet" "pubsubnet" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  vpc_id            = "${aws_vpc.terraform.id}"
  cidr_block        = "${element(var.Psubnet_cidr, count.index)}"
  map_public_ip_on_launch = true
  
  tags = { 
    Name = "subnet-${count.index}" 
  }

}

## Private subnet
resource "aws_subnet" "prvsubnet" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  vpc_id            = "${aws_vpc.terraform.id}"
  cidr_block        = "${element(var.Prvsubnet_cidr, count.index)}"
  
  tags = { 
    Name = "subnet-${count.index}" 
  }

}

resource "aws_security_group" "sg" {
  name        = "sg_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "PING"
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg"
  }
}

