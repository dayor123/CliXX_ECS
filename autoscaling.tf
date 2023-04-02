resource "aws_autoscaling_group" "autoscale" {
  name                      = "Clixx-AG"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.web-private-subnet-1.id, aws_subnet.web-private-subnet-2.id]
  launch_template {
    id = aws_launch_template.ecs.id
  }

  tag {
    key                 = "Name"
    value               = "Clixx_ECS_Cluster"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "autoscale" {
  autoscaling_group_name    = aws_autoscaling_group.autoscale.name
  name                      = "clixx-scale-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 30
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

resource "aws_autoscaling_attachment" "autoscale" {
  autoscaling_group_name = aws_autoscaling_group.autoscale.id
  lb_target_group_arn    = aws_lb_target_group.alb-tg.arn
}