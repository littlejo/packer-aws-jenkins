data "aws_key_pair" "this" {
}

data "aws_iam_policy_document" "this_ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "this" {
  name = "AdministratorAccess"
}


resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
}

resource "aws_security_group" "this" {
  name        = "allow_jenkins"
  description = "Allow jenkins"

  ingress = [
    {
      description      = "jenkins from VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "ssh from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "allow_jenkins"
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "test_profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "instance_role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.this_ec2.json
  managed_policy_arns = [data.aws_iam_policy.this.arn]
}
