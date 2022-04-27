# 7. Create a Network Interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.wiki-subnet.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.allow_all.id]
}

# 8. Assign an elastic IP to the Network Interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.private_ip
  depends_on                = [aws_internet_gateway.wiki-gateway]
}

# 9. Create a server and install/enable apache

resource "aws_instance" "web-server-instance" {
  ami               = data.aws_ami.my_ami.image_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = var.key_name
  #security_groups   = [aws_security_group.allow_all.id]
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

   user_data = file("userdata.sh")


  tags = {
    Name = "DEVOPS16 - WikiMedia"
  }
}