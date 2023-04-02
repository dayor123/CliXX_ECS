resource "aws_ecs_cluster" "ecs_cluster" {
    name  = "Clixx-cluster"
}

# resource "aws_ecs_cluster_capacity_providers" "cluster" {
#   cluster_name = aws_ecs_cluster.ecs_cluster.name

#   capacity_providers = [aws_ecs_capacity_provider.cluster.name]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = aws_ecs_capacity_provider.cluster.name
#   }
# }

resource "aws_ecs_capacity_provider" "cluster" {
  name = "Clixx-cluster"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.autoscale.arn
  }
}