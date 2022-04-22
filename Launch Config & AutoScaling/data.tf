data "aws_ami" "my_ami" {
  most_recent   = true
  owners        = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

output "data-source-ami" {
    value = data.aws_ami.my_ami.image_id
}

data "aws_region" "current" {}

output "current-region" {
    value = data.aws_region.current.id
}