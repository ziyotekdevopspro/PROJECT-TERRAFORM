resource "aws_launch_configuration" "devops16_launch_config" {
  name          = "web_template"
  image_id      = data.aws_ami.my_ami.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  
}