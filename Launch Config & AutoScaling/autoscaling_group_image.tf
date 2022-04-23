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

resource "aws_lb" "devops16_alb_image" {
  name               = "loadbalancer-image"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = [aws_subnet.project-subnet.id, aws_subnet.project-subnet-2.id]

  tags = {
    Environment = "DEVOPS16 Project - Load balancer video"
  }
}

resource "aws_lb_target_group" "devops16_lb_tg_image" {
  name     = "targetgroup-image"
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

resource "aws_lb_listener" "devops16_listener_image" {
  load_balancer_arn = aws_lb.devops16_alb_image.arn
  protocol          = "HTTP"
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops16_lb_tg_image.arn
  }
}

resource "aws_lb_listener_rule" "devops16_listener_rule_image" {
  listener_arn = aws_lb_listener.devops16_listener_image.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops16_lb_tg_image.arn
  }

  condition {
    path_pattern {
      values = ["/image/*"]
    }
  }
}

# Create Target Groups attachment
resource "aws_autoscaling_attachment" "asg_attachment_image" {
  autoscaling_group_name = aws_autoscaling_group.devops16_autoscaling_image.id
  lb_target_group_arn    = aws_lb_target_group.devops16_lb_tg_image.arn
}