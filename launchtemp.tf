data "aws_ami" "stack" {
  owners     = ["681147454489"]
  name_regex = "^"

  filter {
    name   = "name"
    values = ["stack-clixx-ami"]
  }
}

resource "aws_key_pair" "instance-kp" {
  key_name   = "app-key"
  public_key = local.clixx_creds.PATH_TO_PUBLIC_KEY
}

resource "aws_launch_template" "ecs" {
  name = "Clixx-App-LTP"


  disable_api_stop        = false
  disable_api_termination = false

  image_id = var.ami_id

  instance_initiated_shutdown_behavior = "stop"

  instance_type = var.instance_type
  user_data     = base64encode(file("ecs-user-data.sh"))

  iam_instance_profile  {  
    name = aws_iam_instance_profile.ecs_profile.name
  }

  key_name = aws_key_pair.instance-kp.key_name

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.private-sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      GroupName       = "Development"
      OwnerEmail = "ifedayo.obajuluwa@gmail.com"
      Stackteam  = "Stack-Cloud9"
    }
  }

}