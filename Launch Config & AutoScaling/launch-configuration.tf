resource "aws_launch_configuration" "devops16_lc_image" {
  name          = "lc_image"
  image_id      = data.aws_ami.my_ami.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name          = var.key_name
  security_groups   = [aws_security_group.allow_all.id]
  #iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"
  user_data = file("userdata_image.sh")
}

resource "aws_launch_configuration" "devops16_lc_video" {
  name          = "lc_video"
  image_id      = data.aws_ami.my_ami.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name          = var.key_name
  security_groups   = [aws_security_group.allow_all.id]
  #iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"
  user_data = file("userdata_video.sh")
}