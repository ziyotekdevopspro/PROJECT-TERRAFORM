# 1. Create VPC
resource "aws_vpc" "project-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "DEVOPS16 Project VPC"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "project-gateway" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "DEVOPS16 Project Gateway"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "project-routetable" {
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.project-gateway.id
  }

  tags = {
    Name = "DEVOPS16 Project Route Table"
  }
}

# 4. Create Subnets
resource "aws_subnet" "project-subnet" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "DEVOPS16 Project subnet"
  }
}

resource "aws_subnet" "project-subnet-2" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = var.subnet_cidr_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "DEVOPS16 Project subnet 2"
  }
}

# 5. Create Subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.project-subnet.id
  route_table_id = aws_route_table.project-routetable.id
}

# 6. Create Security Group to allow ports:22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_tracffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.project-vpc.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DEVOPS16 Project allow_web"
  }
} 

# 7. Create a Network Interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.project-subnet.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.allow_web.id]
}

# 8. Assign an elastic IP to the Network Interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.private_ip
  depends_on                = [aws_internet_gateway.project-gateway]
}

# 9. Create a server and install/enable apache

resource "aws_instance" "web-server-instance" {
  ami               = data.aws_ami.my_ami.image_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = var.key_name
  security_groups   = aws_security_group.allow_web.id
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = file("userdata_image.sh")


  tags = {
    Name = "DEVOPS16 Project - Web server"
  }
}
