resource "aws_autoscaling_group" "devops16_autoscaling_config" {
  name                      = "web_tier_ag"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = aws_launch_configuration.devops16_launch_config.name
  vpc_zone_identifier       = [aws_subnet.project-subnet.id, aws_subnet.project-subnet-2.id]
  #target_group_arns         = 

  tag {
    key                 = "Name"
    value               = "dev"
    propagate_at_launch = true
  }
 }