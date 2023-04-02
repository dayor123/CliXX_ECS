resource "aws_ecs_task_definition" "aws-ecs-task" {
  family                   = "Clixx-ECS-Task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = 900
  cpu                      = 512

  execution_role_arn = "arn:aws:iam::342652145440:role/ecs_instance_role" 
  task_role_arn      = "arn:aws:iam::342652145440:role/ecs_instance_role"
  container_definitions = jsonencode([
    {
      name      = "Clixx-container"
      image     = "681147454489.dkr.ecr.us-east-1.amazonaws.com/clixx-repo:clixx-image-1.0.30"
      cpu       = 10
      memory    = 300
      essential = true
      memory_reservation = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}