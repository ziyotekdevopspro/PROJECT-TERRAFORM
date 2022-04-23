resource "aws_autoscaling_group" "devops16_autoscaling_image" {
  name                      = "image"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = aws_launch_configuration.devops16_lc_image.name
  vpc_zone_identifier       = [aws_subnet.project-subnet.id, aws_subnet.project-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "devops16-project-image"
    propagate_at_launch = true
  }
 }

 resource "aws_autoscaling_group" "devops16_autoscaling_video" {
  name                      = "video"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = aws_launch_configuration.devops16_lc_video.name
  vpc_zone_identifier       = [aws_subnet.project-subnet.id, aws_subnet.project-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "devops16-project-video"
    propagate_at_launch = true
  }
 }

 resource "aws_lb" "devops16_alb_config" {
  name               = "web-tier-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = [aws_subnet.project-subnet.id, aws_subnet.project-subnet-2.id]

  tags = {
    Environment = "DEVOPS16 Project"
  }
}

resource "aws_lb_listener" "devops16_listener_config" {
  load_balancer_arn = aws_lb.devops16_alb_config.arn
  protocol          = "HTTP"
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops16_lb_tg_config.arn
  }
}

# Forward action

resource "aws_lb_listener_rule" "devops16_listener_rule_config" {
  listener_arn = aws_lb_listener.devops16_listener_config.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops16_lb_tg_config.arn
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }
}


resource "aws_lb_target_group" "devops16_lb_tg_config" {
  name     = "web-tier-lb-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.project-vpc.id
  health_check {
    unhealthy_threshold = 3
    healthy_threshold = 10
    timeout = 5
    interval = 30
    path = "/"
    port = "traffic-port"
    matcher = "200-400" #success code
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.devops16_autoscaling_image.id
  lb_target_group_arn    = aws_lb_target_group.devops16_lb_tg_config.arn
}