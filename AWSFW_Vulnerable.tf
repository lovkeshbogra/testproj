provider "aws" {
 region = "ap-northeast-3"
}

data "aws_vpc" "default" {
 default = true
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_RDP"
  description = "Allow RDP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "RDP from VPC"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_RDP"
  }
}