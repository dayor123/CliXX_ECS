resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "Clixx-ecs-service"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "EC2"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true
  health_check_grace_period_seconds = 300
  iam_role = "arn:aws:iam::342652145440:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    container_name   = "Clixx-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.alb-listner]
}
  