# data "template_file" "bootstrap" {
#     template = file("${path.module}/scripts/bootstrap.sh")
# }
data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret_version" "clixxcreds" {
  # Fill in the name you gave to your secret
  secret_id = "ClixxCreds"
}

# data "template_file" "ecs_user_data" {
#   template = file("ecs-user-data.sh")

#   vars = {
#   }
# }
