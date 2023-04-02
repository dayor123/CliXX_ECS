
# #Create Bastion Host & LB Subnet 
# resource "aws_subnet" "public-subnet-1" {
#   vpc_id            = aws_vpc.dev-vpc.id
#   cidr_block        = "10.1.8.0/23"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "Public-Subnet-1a"
#   }
# }

# resource "aws_subnet" "public-subnet-2" {
#   vpc_id            = aws_vpc.dev-vpc.id
#   cidr_block        = "10.1.10.0/23"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "Public-Subnet-1b"
#   }
# }

# #Create Intenet Gatway
# resource "aws_internet_gateway" "dev-gw" {
#   vpc_id = aws_vpc.dev-vpc.id

#   tags = {
#     Name = "Stack_IGW"
#   }
# }

# #Nat Gateway for Private Subnets
# resource "aws_eip" "ip" {
#   vpc = true
# }

# resource "aws_eip" "ip2" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.ip.id
#   subnet_id     = aws_subnet.public-subnet-1.id

#   tags = {
#     Name = "Stack_NATGW"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.dev-gw]
# }

# resource "aws_nat_gateway" "nat_gw2" {
#   allocation_id = aws_eip.ip2.id
#   subnet_id     = aws_subnet.public-subnet-2.id

#   tags = {
#     Name = "Stack_NATGW_2"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.dev-gw]
# }


# #webapp route table
# resource "aws_route_table" "webapp" {
#   vpc_id = aws_vpc.dev-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat_gw.id
#   }

#   tags = {
#     Name = "Private-Route-Table"
#   }
# }

# resource "aws_route_table" "webapp2" {
#   vpc_id = aws_vpc.dev-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat_gw2.id
#   }

#   tags = {
#     Name = "Private-Route-Table-2"
#   }
# }

# #public subnet route table
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.dev-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.dev-gw.id
#   }
#   tags = {
#     Name = "Public-Route-Table"
#   }
# }


# # webapp subnet and route table association 
# resource "aws_route_table_association" "webapp-private-1" {
#   subnet_id      = aws_subnet.web-private-subnet-1.id
#   route_table_id = aws_route_table.webapp.id

# }

# resource "aws_route_table_association" "webapp-private-2" {
#   subnet_id      = aws_subnet.web-private-subnet-2.id
#   route_table_id = aws_route_table.webapp2.id

# }

# #Public Subne and route table association
# resource "aws_route_table_association" "public-1" {
#   subnet_id      = aws_subnet.public-subnet-1.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "public-2" {
#   subnet_id      = aws_subnet.public-subnet-2.id
#   route_table_id = aws_route_table.public.id
# }

# output "vpc-id" {
#   value = aws_vpc.dev-vpc.id
# }

# output "nat_gateway_ips" {
#   value = aws_nat_gateway.nat_gw.public_ip
# }

# output "nat_gateway_ips2" {
#   value = aws_nat_gateway.nat_gw2.public_ip
# }

# #Create Security Group
# resource "aws_security_group" "pub-instance-sg" {
#   vpc_id      = aws_vpc.dev-vpc.id
#   name        = "Dev-WebDMZ"
#   description = "Security Group For Bastion Host & Load Balancer"
# }
# #Add rule to SSH into EC2 instance
# resource "aws_security_group_rule" "pub-ssh" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 22
#   to_port           = 22
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "pub-http-rule" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# resource "aws_security_group_rule" "pub-https-rule" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# resource "aws_security_group_rule" "pub-rds-rule" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 3306
#   to_port           = 3306
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# resource "aws_security_group_rule" "pub-nfs-rule" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 2049
#   to_port           = 2049
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# resource "aws_security_group_rule" "pub-oracle-rule" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 1521
#   to_port           = 1521
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "pub-egress-rule" {
#   security_group_id = aws_security_group.pub-instance-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# resource "aws_security_group" "private-sg" {
#   vpc_id      = aws_vpc.dev-vpc.id
#   name        = "Private_SG"
#   description = "Security Group For Private Instance"
# }

# resource "aws_security_group_rule" "pri-http-rule" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = [aws_subnet.public-subnet-1.cidr_block, aws_subnet.public-subnet-2.cidr_block]
# }

# resource "aws_security_group_rule" "pri-https-rule" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = [aws_subnet.public-subnet-1.cidr_block, aws_subnet.public-subnet-2.cidr_block]
# }

# resource "aws_security_group_rule" "pri-ssh-rule" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 22
#   to_port           = 22
#   cidr_blocks       = [aws_subnet.public-subnet-1.cidr_block, aws_subnet.public-subnet-2.cidr_block]
# }

# resource "aws_security_group_rule" "pri-rdsaurora-rule" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 3306
#   to_port           = 3306
#   cidr_blocks       = [aws_subnet.public-subnet-1.cidr_block, aws_subnet.public-subnet-2.cidr_block]
# }

# resource "aws_security_group_rule" "pri-oracle-rule" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 1521
#   to_port           = 1521
#   cidr_blocks       = [aws_subnet.public-subnet-1.cidr_block, aws_subnet.public-subnet-2.cidr_block]
# }

# resource "aws_security_group_rule" "pri-efs-rule" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 2049
#   to_port           = 2049
#   cidr_blocks       = [aws_subnet.public-subnet-1.cidr_block, aws_subnet.public-subnet-2.cidr_block]
# }

# resource "aws_security_group_rule" "private-egress" {
#   security_group_id = aws_security_group.private-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# resource "aws_security_group" "efs-sg" {
#   vpc_id      = aws_vpc.dev-vpc.id
#   name        = "EFS-TF-SG"
#   description = "Security Group For EFS"
# }

# resource "aws_security_group_rule" "efs-ssh" {
#   security_group_id        = aws_security_group.efs-sg.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = 22
#   to_port                  = 22
#   source_security_group_id = aws_security_group.private-sg.id
# }

# resource "aws_security_group_rule" "efs-nfs" {
#   security_group_id        = aws_security_group.efs-sg.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = 2049
#   to_port                  = 2049
#   source_security_group_id = aws_security_group.private-sg.id
# }

# resource "aws_security_group_rule" "efs-egress" {
#   security_group_id = aws_security_group.efs-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# #Security Group for RDS 
# resource "aws_security_group" "rdsdatabase-sg" {
#   vpc_id      = aws_vpc.dev-vpc.id
#   name        = "RDS_SG"
#   description = "Security Group For RDS"
# }

# resource "aws_security_group_rule" "rdsaurora" {
#   security_group_id        = aws_security_group.rdsdatabase-sg.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = 3306
#   to_port                  = 3306
#   source_security_group_id = aws_security_group.private-sg.id
# }

# resource "aws_security_group_rule" "rdsaurora-egress" {
#   security_group_id = aws_security_group.rdsdatabase-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]

# }

# #Load Balancer in the Public Subnet 
# resource "aws_lb" "alb" {
#   name               = "clixx-app-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.pub-instance-sg.id]
#   subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

#   enable_deletion_protection = false

#   tags = {
#     Environment = "Development"
#   }
# }

# resource "aws_lb_target_group" "dev-tg" {
#   name     = "clixx-app-tg-1"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.dev-vpc.id

#   health_check {
#     port     = 80
#     protocol = "HTTP"
#   }

# }

# resource "aws_lb_listener" "dev-lb-list" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.dev-tg.arn
#   }
# }

# output "dev-lb-dns-name" {
#   value = aws_lb.alb.dns_name
# }

# #RDS for Web Application 
# resource "aws_db_snapshot_copy" "rds" {
#   source_db_snapshot_identifier = local.clixx_creds.sharedsnapshot
#   target_db_snapshot_identifier = "wordpressdbclixx"
# }

# resource "aws_db_subnet_group" "clixx-rds" {
#   name       = "clixx-multi-az-subnet-group"
#   subnet_ids = [aws_subnet.db-private-subnet-1.id, aws_subnet.db-private-subnet-2.id]

#   tags = {
#     Name = "Multi-AZ Subnet Group for RDS"
#   }
# }

# resource "aws_db_instance" "rds" {
#   allocated_storage      = 20
#   engine                 = "mysql"
#   instance_class         = "db.t3.micro"
#   db_name                = local.clixx_creds.dbname
#   password               = local.clixx_creds.password
#   username               = local.clixx_creds.username
#   identifier             = "wordpressdbclixx"
#   snapshot_identifier    = aws_db_snapshot_copy.rds.id
#   skip_final_snapshot    = true
#   vpc_security_group_ids = [aws_security_group.rdsdatabase-sg.id]
#   db_subnet_group_name   = aws_db_subnet_group.clixx-rds.name


#   maintenance_window      = "Fri:09:00-Fri:09:30"
#   backup_retention_period = 0
#   parameter_group_name    = "default.mysql8.0"
# }

# output "rds-endpoint" {
#   value = aws_db_instance.rds.address
# }

# data "aws_ami" "stack" {
#   owners     = ["681147454489"]
#   name_regex = "^"

#   filter {
#     name   = "name"
#     values = ["stack-clixx-ami"]
#   }
# }
  
# resource "aws_iam_instance_profile" "clixx-instance" {
#   name = "ec2_profile"
#   role = aws_iam_role.role.name
# }

# #Application Launch Template
# resource "aws_launch_template" "dev" {
#   name = "Clixx-App-LTP"


#   disable_api_stop        = false
#   disable_api_termination = false

#   image_id = data.aws_ami.stack.id

#   instance_initiated_shutdown_behavior = "stop"

#   instance_type = var.instance_type

#   iam_instance_profile  {  
#     name = "ec2_profile"
#   }

#   key_name = aws_key_pair.instance-kp.key_name

#   monitoring {
#     enabled = true
#   }

#   vpc_security_group_ids = [aws_security_group.private-sg.id]

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       GroupName       = "Development"
#       OwnerEmail = "ifedayo.obajuluwa@gmail.com"
#       Stackteam  = "Stack-Cloud9"
#     }
#   }

#   user_data = "${base64encode(<<EOF
#     ${templatefile("${path.module}/script/webappbootstrap.sh", { FILE_SYSTEM = aws_efs_file_system.efs.dns_name, LOAD_BALANCER = aws_lb.alb.dns_name, DBNAME = local.clixx_creds.dbname, USERNAME = local.clixx_creds.username, PASSWORD = local.clixx_creds.password, HOSTNAME = aws_db_instance.rds.address, vol = "[\"${join("\", \"", var.dev_names)}\"]", dsk = "[\"${join("\", \"", var.dsk_names)}\"]" })}
#     EOF
#  )}"

#   dynamic "block_device_mappings" {
#     for_each = [for vol in var.dev_names : {
#       device_name           = "/dev/${vol}"
#       virtual_name          = "ebs_dsk-${vol}"
#       delete_on_termination = true
#       encrypted             = false
#       volume_size           = 10
#       volume_type           = "gp2"
#     }]
#     content {
#       device_name  = block_device_mappings.value.device_name
#       virtual_name = block_device_mappings.value.virtual_name

#       ebs {
#         delete_on_termination = block_device_mappings.value.delete_on_termination
#         encrypted             = block_device_mappings.value.encrypted
#         volume_size           = block_device_mappings.value.volume_size
#         volume_type           = block_device_mappings.value.volume_type
#       }
#     }
#   }
# }


# #Bastion Host Launch Template 
# resource "aws_launch_template" "bastion" {
#   name = "Bastion-LTP"


#   disable_api_stop        = false
#   disable_api_termination = false

#   image_id = data.aws_ami.stack.id

#   instance_initiated_shutdown_behavior = "stop"

#   instance_type = var.instance_type

#   iam_instance_profile  {  
#     name = "ec2_profile"
#   }

#   key_name = aws_key_pair.bastion-kp.key_name

#   monitoring {
#     enabled = true
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     device_index                = 0
#     security_groups             = [aws_security_group.pub-instance-sg.id]
#   }

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       GroupName       = "Development"
#       OwnerEmail = "ifedayo.obajuluwa@gmail.com"
#       Stackteam  = "Stack-Cloud9"
#     }
#   }

# }



# #Create Autoscaling Group in Private Subnet for Web Application
# resource "aws_key_pair" "instance-kp" {
#   key_name   = "app-key"
#   public_key = local.clixx_creds.PATH_TO_PUBLIC_KEY
# }

# resource "aws_autoscaling_group" "autoscale" {
#   name                      = "Clixx-AG"
#   max_size                  = 3
#   min_size                  = 1
#   health_check_grace_period = 30
#   health_check_type         = "EC2"
#   desired_capacity          = 1
#   force_delete              = true
#   vpc_zone_identifier       = [aws_subnet.web-private-subnet-1.id, aws_subnet.web-private-subnet-2.id]
#   launch_template {
#     id = aws_launch_template.dev.id
#   }

#   tag {
#     key                 = "Name"
#     value               = "Clixx_Web_App"
#     propagate_at_launch = true
#   }

# }

# resource "aws_autoscaling_policy" "autoscale" {
#   autoscaling_group_name    = aws_autoscaling_group.autoscale.name
#   name                      = "clixx-scale-policy"
#   policy_type               = "TargetTrackingScaling"
#   estimated_instance_warmup = 30
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 50.0
#   }
# }

# resource "aws_autoscaling_attachment" "autoscale" {
#   autoscaling_group_name = aws_autoscaling_group.autoscale.id
#   lb_target_group_arn    = aws_lb_target_group.dev-tg.arn
# }


# #Create Bastion Host in Public Subnet with Autoscaling group
# resource "aws_key_pair" "bastion-kp" {
#   key_name   = "web_dmz-key"
#   public_key = local.clixx_creds.PATH_TO_BASTION_PUBLIC_KEY
# }

# resource "aws_autoscaling_group" "bastion" {
#   name                      = "Bastion-Host"
#   max_size                  = 2
#   min_size                  = 1
#   health_check_grace_period = 30
#   health_check_type         = "EC2"
#   desired_capacity          = 1
#   force_delete              = true
#   vpc_zone_identifier       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
#   launch_template {
#     id = aws_launch_template.bastion.id
#   }

#   tag {
#     key                 = "Name"
#     value               = "Clixx_Bastion_Host"
#     propagate_at_launch = true
#   }

# }

# resource "aws_autoscaling_policy" "bastion" {
#   autoscaling_group_name    = aws_autoscaling_group.bastion.name
#   name                      = "clixx-scale-policy"
#   policy_type               = "TargetTrackingScaling"
#   estimated_instance_warmup = 30
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 50.0
#   }
# }

# #efs Mount
# resource "aws_efs_file_system" "efs" {
#   creation_token = "Stack"

#   tags = {
#     Name = "Stack-EFS"
#   }

# }

# resource "aws_efs_mount_target" "mount" {
#   file_system_id  = aws_efs_file_system.efs.id
#   subnet_id       = aws_subnet.web-private-subnet-1.id
#   security_groups = [aws_security_group.efs-sg.id]
# }

# resource "aws_efs_mount_target" "mount2" {
#   file_system_id  = aws_efs_file_system.efs.id
#   subnet_id       = aws_subnet.web-private-subnet-2.id
#   security_groups = [aws_security_group.efs-sg.id]
# }

# resource "null_resource" "configure_nfs" {
#   depends_on = [aws_efs_mount_target.mount]
#   connection {
#     type       = "ssh"
#     user       = "ec2-user"
#     public_key = aws_key_pair.instance-kp.key_name
#   }
# }

# resource "null_resource" "configure_nfs2" {
#   depends_on = [aws_efs_mount_target.mount2]
#   connection {
#     type       = "ssh"
#     user       = "ec2-user"
#     public_key = aws_key_pair.instance-kp.key_name
#   }
# }
# output "efs-dns-name" {
#   value = aws_efs_file_system.efs.dns_name
# }