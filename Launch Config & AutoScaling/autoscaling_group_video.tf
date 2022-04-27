resource "aws_autoscaling_group" "devops16_autoscaling_video" {
  name                      = "video"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = aws_launch_configuration.devops16_lc_video.name
  vpc_zone_identifier       = [aws_subnet.project-subnet.id,aws_subnet.project-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "${var.environment} - video"
    propagate_at_launch = true
  }
 }

resource "aws_lb" "devops16_alb_video" {
  name               = "loadbalancer-video"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all.id]
  subnets            = [aws_subnet.project-subnet.id,aws_subnet.project-subnet-2.id]

  tags = {
    key                 = "Name"
    value               = "${var.environment} - Load balancer video"
  }
}

resource "aws_lb_target_group" "devops16_lb_tg_video" {
  name     = "targetgroup-video"
  port     = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.project-vpc.id
  health_check {
    unhealthy_threshold = 3
    healthy_threshold = 10
    timeout = 5
    interval = 30
    path = "/videos/"
    port = "traffic-port"
    matcher = "200-400" #success code
  }
}

resource "aws_lb_listener" "devops16_listener_video" {
  load_balancer_arn = aws_lb.devops16_alb_video.arn
  protocol          = "HTTP"
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops16_lb_tg_video.arn
  }
}

resource "aws_lb_listener_rule" "devops16_listener_rule_video" {
  listener_arn = aws_lb_listener.devops16_listener_video.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops16_lb_tg_video.arn
  }

  condition {
    path_pattern {
      values = ["*/videos*"]
    }
  }
}

# Create Target Groups attachment
resource "aws_autoscaling_attachment" "asg_attachment_video" {
  autoscaling_group_name = aws_autoscaling_group.devops16_autoscaling_video.id
  lb_target_group_arn    = aws_lb_target_group.devops16_lb_tg_video.arn
}