#Private Subnet Security Group
resource "aws_security_group" "private-sg" {
  vpc_id      = aws_vpc.dev-vpc.id
  name        = "Private_SG"
  description = "Security Group For ECS Private Instance"
}

resource "aws_security_group_rule" "ECS-http-rule" {
  security_group_id = aws_security_group.private-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  source_security_group_id = aws_security_group.pub-instance-sg.id
}

resource "aws_security_group_rule" "ECS-https-rule" {
  security_group_id = aws_security_group.private-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  source_security_group_id = aws_security_group.pub-instance-sg.id
}

resource "aws_security_group_rule" "ECS-ssh-rule" {
  security_group_id = aws_security_group.private-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  source_security_group_id = aws_security_group.pub-instance-sg.id
}

resource "aws_security_group_rule" "private-egress" {
  security_group_id = aws_security_group.private-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]

}

#RDS Security Group
resource "aws_security_group" "rdsdatabase-sg" {
  vpc_id      = aws_vpc.dev-vpc.id
  name        = "RDS_SG"
  description = "Security Group For RDS"
}

resource "aws_security_group_rule" "rdsaurora" {
  security_group_id        = aws_security_group.rdsdatabase-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.private-sg.id
}

resource "aws_security_group_rule" "rdsaurora-egress" {
  security_group_id = aws_security_group.rdsdatabase-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

#Public Subnet Security Group for LB
resource "aws_security_group" "pub-instance-sg" {
  vpc_id      = aws_vpc.dev-vpc.id
  name        = "Dev-WebDMZ"
  description = "Security Group For Public Host & Load Balancer"
}

resource "aws_security_group_rule" "pub-ssh" {
  security_group_id = aws_security_group.pub-instance-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub-http-rule" {
  security_group_id = aws_security_group.pub-instance-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "pub-https-rule" {
  security_group_id = aws_security_group.pub-instance-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "pub-egress-rule" {
  security_group_id = aws_security_group.pub-instance-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.dev-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.pub-instance-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}